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
        ? allEvents.where((event) {
            return !event.isCompleted &&
                !_isDatePast(context, event.date, event.time);
          }).toList()
        : List.from(allEvents);

    displayEvents.sort(((a, b) {
      try {
        List<String> datePartsA = a.date.split('/');
        List<String> timePartsA = a.time.split(":");
        DateTime dateTimeA = DateTime(
          int.parse(datePartsA[2]),
          int.parse(datePartsA[1]),
          int.parse(datePartsA[0]),
          int.parse(timePartsA[0]),
          int.parse(timePartsA[1]),
        );

        List<String> datePartsB = b.date.split('/');
        List<String> timePartsB = b.time.split(":");
        DateTime dateTimeB = DateTime(
          int.parse(datePartsB[2]),
          int.parse(datePartsB[1]),
          int.parse(datePartsB[0]),
          int.parse(timePartsB[0]),
          int.parse(timePartsB[1]),
        );

        return dateTimeA.compareTo(dateTimeB);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sortting Error! $e"),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        return 0;
      }
    }));
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),

                    ActionChip(
                      avatar: Icon(
                        onlyUncompleted
                            ? Icons.check_circle_outline_rounded
                            : Icons.list_alt_rounded,
                        size: 15,
                        color: onlyUncompleted
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(
                        onlyUncompleted ? "Active Only" : "Show Uncompleted",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: displayEvents.length,
                        itemBuilder: (context, index) {
                          final event = displayEvents[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ListCardview(
                              id: event.id.toString(),
                              name: event.title,
                              description: event.description,
                              date: event.date,
                              time: event.time,
                              isCompleted: event.isCompleted,

                              onCheckPressed: () {
                                ref
                                    .read(eventListProvider.notifier)
                                    .toggleCheck(event.id);
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

  bool _isDatePast(
    BuildContext context,
    String eventDateStr,
    String eventTimeStr,
  ) {
    try {
      List<String> dateparts = eventDateStr.split('/');
      List<String> timeparts = eventTimeStr.split(':');

      if (dateparts.length != 3 && timeparts.length != 2) return false;

      int day = int.parse(dateparts[0]);
      int month = int.parse(dateparts[1]);
      int year = int.parse(dateparts[2]);
      int hour = int.parse(timeparts[0]);
      int minute = int.parse(timeparts[1]);

      DateTime eventDate = DateTime(year, month, day, hour, minute);
      DateTime today = DateTime.now();

      return eventDate.isBefore(today);
    } catch (e) {
      print('Date checking error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Date checking error: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return false;
    }
  }
}
