import 'package:flutter/material.dart';
import 'package:reminder/models/event_model.dart';

class AddView extends StatelessWidget {
  const AddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 114),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                child: TextField(
                  maxLines: 15,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),

                    hint: Text(
                      "There's a meeting tomorrow at 8:40.",
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.tertiary.withOpacity(0.5),
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    EventModel eventnew = EventModel(
                      title: 'title',
                      date: '26/05',
                      time: '18.00',
                    );
                  },
                  child: const Text(
                    "ADD EVENT",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
