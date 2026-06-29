import 'package:flutter/material.dart';

class ListCardview extends StatelessWidget {
  final String name;
  final String description;
  final String date;
  final String time;
  final bool isCompleted;
  final VoidCallback onCheckPressed;
  final VoidCallback onDeletePressed;

  const ListCardview({
    super.key,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.isCompleted,
    required this.onCheckPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 100,
          width: 520,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: _listCardWidget(
              context,
              event: name,
              date: date,
              time: time,
            ),
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.check_circle_outline_rounded),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              iconSize: 30,
            ),
            SizedBox(height: 10),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete_outline),
              color: Theme.of(context).colorScheme.error,
              iconSize: 30,
            ),
          ],
        ),
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
}
