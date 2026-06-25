import 'package:flutter/material.dart';
import 'package:reminder/pages/widgets/list_cardview.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 21),
          child: Column(
            children: [
              ListCardview(name: "Meeting", date: "25/06/2026", time: "8.40"),
              SizedBox(height: 10),
              ListCardview(name: "Date", date: "25/06/2026", time: "8.40"),
              SizedBox(height: 10),
              ListCardview(name: "Sport", date: "25/06/2026", time: "8.40"),
              SizedBox(height: 10),
              ListCardview(name: "Exam", date: "25/06/2026", time: "8.40"),
            ],
          ),
        ),
      ),
    );
  }
}
