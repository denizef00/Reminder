import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/pages/widgets/info_cardview.dart';
import 'package:reminder/pages/widgets/swip_cardwidget.dart';
//import 'package:reminder/services/notification_services.dart';

class ListCardview extends ConsumerWidget {
  final String id;
  final String name;
  final String description;
  final String date;
  final String time;
  final bool isCompleted;
  final VoidCallback onCheckPressed;
  final VoidCallback onDeletePressed;

  ListCardview({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    this.isCompleted = false,
    required this.onCheckPressed,
    required this.onDeletePressed,
  });
  final minuteTickProvider = StreamProvider<int>((ref) {
    return Stream.periodic(
      const Duration(seconds: 30),
      (computationCount) => computationCount,
    );
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPast = _checkDate(date, time);
    final status = isCompleted || isPast;
    ref.watch(minuteTickProvider);
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        SwipCardwidget(
          onTap: () {
            InfoCard.show(
              context,
              ref,
              id: id,
              name: name,
              description: description,
              date: date,
              time: time,
              onCheckPressed: onCheckPressed,
              onDeletePressed: onDeletePressed,
              onConfirm: () {},
              buttonName1: "Cancel",
              buttonName2: "Accept",
              edittingMode: true,
            );
          },

          onDelete: () {
            onDeletePressed();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Event succesfully deleted on your list!!"),
              ),
            );
          },
          onCheck: () {
            if (isPast) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "This event is over!\nYou can edit the event details!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else {
              onCheckPressed();
            }
          },
          status: status,

          child: Container(
            height: 100,
            width: 520,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: !status
                  ? _listCardWidget(
                      context,
                      event: name,
                      date: date,
                      time: time,
                    )
                  : _completeCardWidget(
                      context,
                      event: name,
                      date: date,
                      time: time,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Column _completeCardWidget(
    BuildContext context, {
    required String event,
    required String date,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        _completeNameWidget(context, event: event),
        SizedBox(height: 15),
        _completeTimeWidget(context, date: date, time: time),
      ],
    );
  }

  Column _listCardWidget(
    BuildContext context, {
    required String event,
    required String date,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        _nameWidget(context, event: event),
        SizedBox(height: 15),
        _timeWidget(context, date: date, time: time),
      ],
    );
  }

  Row _timeWidget(
    BuildContext context, {
    required String date,
    required String time,
  }) {
    return Row(
      children: [
        SizedBox(width: 27),
        Text(
          date,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 10),
        Text(
          " • ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 10),

        Text(
          time,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _nameWidget(BuildContext context, {required String event}) {
    return Row(
      children: [
        SizedBox(width: 27),
        Text(
          event,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _completeNameWidget(BuildContext context, {required String event}) {
    return Row(
      children: [
        SizedBox(width: 27),
        Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(
              context,
            ).colorScheme.tertiary.withOpacity(0.4), // %40 görünürlük (soluk)

            decoration: TextDecoration.lineThrough,

            decorationColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.5), // Çizgi rengi
            decorationThickness: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _completeTimeWidget(
    BuildContext context, {
    required String date,
    required String time,
  }) {
    return Row(
      children: [
        SizedBox(width: 27),
        Text(
          date,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
            fontSize: 16,
          ),
        ),
        SizedBox(width: 10),
        Text(
          " • ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
          ),
        ),
        SizedBox(width: 10),

        Text(
          time,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  bool _checkDate(String eventDateStr, String eventTimeStr) {
    try {
      List<String> dateParts = eventDateStr.split('/');
      if (dateParts.length != 3) return false;

      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      List<String> timeParts = eventTimeStr.split(':');
      int hour = timeParts.length > 0 ? int.parse(timeParts[0]) : 0;
      int minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;

      DateTime eventDateTime = DateTime(year, month, day, hour, minute);

      return eventDateTime.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}
