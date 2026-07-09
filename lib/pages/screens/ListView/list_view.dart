import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:reminder/pages/widgets/list_cardview.dart';
import 'package:reminder/providers/event_provider.dart';

final onlyUncompletedProvider = StateProvider<bool>((ref) => false);

class ListPage extends ConsumerWidget {
  const ListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEvents = ref.watch(eventListProvider);
    final onlyUncompleted = ref.watch(onlyUncompletedProvider);
    final displayEvents = onlyUncompleted
        ? allEvents.where((event) => !event.isCompleted).toList()
        : allEvents;
    //final eventList = ref.watch(eventListProvider);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 21),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reminders',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),

                    ActionChip(
                      avatar: Icon(
                        onlyUncompleted
                            ? Icons.check_circle_outline_rounded
                            : Icons.list_alt_rounded,
                        size: 18,
                        color: onlyUncompleted
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(
                        onlyUncompleted ? "Active Only" : "Show Uncompleted",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: onlyUncompleted
                              ? Colors.white
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      backgroundColor: onlyUncompleted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      side: BorderSide(
                        color: onlyUncompleted
                            ? Colors.transparent
                            : Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        ref.read(onlyUncompletedProvider.notifier).state =
                            !onlyUncompleted;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Expanded(
                child: displayEvents.isEmpty
                    ? Center(
                        child: Text(
                          onlyUncompleted
                              ? "No active tasks left!"
                              : "No events have been added yet.\nYou can add them from the 'Add Event' screen!",
                        ),
                      )
                    : ListView.builder(
                        itemCount: displayEvents.length,
                        itemBuilder: (context, index) {
                          final event = displayEvents[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ListCardview(
                              id: event.id,
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
            ],
          ),
        ),
      ),
    );
  }
}
