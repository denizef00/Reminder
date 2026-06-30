import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/pages/widgets/list_cardview.dart';
import 'package:reminder/providers/event_provider.dart';

class ListPage extends ConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventList = ref.watch(eventListProvider);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 21),
          child: eventList.isEmpty
              ? const Center(
                  child: Text(
                    "No events have been added yet.\nYou can add them from the main screen!",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: eventList.length,
                  itemBuilder: (context, index) {
                    final event = eventList[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ListCardview(
                        name: event.title,
                        description: event.description,
                        date: event.date,
                        time: event.time,
                        isCompleted: event.isCompleted,

                        onCheckPressed: () {
                          ref
                              .read(eventListProvider.notifier)
                              .toggleCheck(event.id);
                          final guncel = ref
                              .read(eventListProvider)
                              .firstWhere((e) => e.id == event.id);

                          print(guncel.isCompleted);
                        },
                        onDeletePressed: () {
                          ref
                              .read(eventListProvider.notifier)
                              .deleteEvent(event.id);
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
