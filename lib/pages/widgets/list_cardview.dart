import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reminder/providers/event_provider.dart';

class ListCardview extends ConsumerWidget {
  final String id;
  final String name;
  final String description;
  final String date;
  final String time;
  final bool isCompleted;
  final VoidCallback onCheckPressed;
  final VoidCallback onDeletePressed;

  const ListCardview({
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullTime = DateTime.now();
    final dateNow = DateFormat("dd/MM/yyyy").format(fullTime);
    final timeNow = DateFormat("HH:mm").format(fullTime);
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GestureDetector(
          onTap: () {
            _infoCard(
              context,
              ref,
              name: name,
              desciptiom: description,
              date: dateNow,
              time: timeNow,
            );
          },
          child: Container(
            height: 100,
            width: 520,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: !isCompleted
                  ? _listCardWidget(
                      context,
                      event: name,
                      date: dateNow,
                      time: timeNow,
                    )
                  : _completeCardWidget(
                      context,
                      event: name,
                      date: dateNow,
                      time: timeNow,
                    ),
            ),
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: onCheckPressed,
              icon: const Icon(Icons.check_circle_outline_rounded),
              color: !isCompleted
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
              iconSize: 30,
            ),
          ],
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

  void _infoCard(
    BuildContext context,
    WidgetRef ref, {
    required String name,
    required String desciptiom,
    required String date,
    required String time,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          backgroundColor: Colors.transparent,
          elevation: 8,
          content: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Event Details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Event Name : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Text(
                            'Event Description : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            desciptiom,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Text(
                            'Event Date : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),

                      Row(
                        children: [
                          Text(
                            "Event Time : ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  minimumSize: const Size(50, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      24,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_note_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Edit",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  padding: EdgeInsets.symmetric(vertical: 10),

                                  minimumSize: const Size(50, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      24,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ref
                                      .read(eventListProvider.notifier)
                                      .deleteEvent(id);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Event succesfully deleted!!',
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },

                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Delete",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
