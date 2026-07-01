import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Text(
        "Calender View",
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
      ),
    );
  }
}
