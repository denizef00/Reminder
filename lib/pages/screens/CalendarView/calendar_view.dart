import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/models/event_model.dart';
import 'package:reminder/pages/widgets/info_cardview.dart';
import 'package:reminder/providers/event_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});
  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final allEvents = ref.watch(eventListProvider);
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2025),
              lastDay: DateTime.utc(2040),
              onDaySelected: _onDaySelected,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) {
                return allEvents
                    .where((event) => _isSameDayWithEvent(day, event.date))
                    .toList();
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(child: _buildSelectedDayEventsList(allEvents)),
          ],
        ),
      ),
    );
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _selectedDay = day;
      _focusedDay = focusedDay;
    });
  }

  bool _isSameDayWithEvent(DateTime calendarDay, String eventDateStr) {
    try {
      List<String> parts = eventDateStr.split('/');
      if (parts.length != 3) return false;
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      return calendarDay.year == year &&
          calendarDay.month == month &&
          calendarDay.day == day;
    } catch (e) {
      print('_isSameDayWithEvent fonskiyonunda hata : $e');
      return false;
    }
  }

  Widget _buildSelectedDayEventsList(List<EventModel> allEvents) {
    final activeEvents = allEvents.where((event) {
      return _isSameDayWithEvent(_selectedDay, event.date);
    }).toList();

    activeEvents.sort((a, b) {
      try {
        final timePartsA = a.time.split(":");

        final timePartsB = b.time.split(":");

        final aHour = int.parse(timePartsA[0]);
        final aMinute = int.parse(timePartsA[1]);

        final bHour = int.parse(timePartsB[0]);
        final bMinute = int.parse(timePartsB[1]);

        if (aHour != bHour) {
          return aHour.compareTo(bHour);
        } else {
          return aMinute.compareTo(bMinute);
        }
      } catch (e) {
        return a.time.compareTo(b.time);
      }
    });

    if (activeEvents.isEmpty) {
      return const Center(child: Text('No events scheduled for this day,'));
    }
    return ListView.builder(
      itemCount: activeEvents.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final event = activeEvents[index];

        final bool status = event.isCompleted;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            InfoCard.show(
              context,
              ref,
              id: event.id,
              name: event.title,
              description: event.description,
              date: event.date,
              time: event.time,
              onCheckPressed: () {},
              onDeletePressed: () {},
              onConfirm: () {},
              buttonName1: "Cancel",
              buttonName2: "Accept",
              edittingMode: true,
            );
            /*_infoCard(
              context,
              ref,
              event: event,
              name: event.title,
              description: event.description,
              date: event.date,
              time: event.time,
            );*/
          },
          child: Opacity(
            opacity: status ? 0.5 : 1,
            child: Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  event.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(event.time),
                trailing: IconButton(
                  onPressed: () {
                    ref
                        .read(eventListProvider.notifier)
                        .toggleCheck(event.id.toString());
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  color: event.isCompleted
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                  iconSize: 30,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
