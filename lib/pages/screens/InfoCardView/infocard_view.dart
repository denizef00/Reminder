import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String time;
  final bool isComplete;

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 5,
      decoration: BoxDecoration(
        color: Colors.transparent,

        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("S"),
          ),
        ],
      ),
    );
  }
}
