import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/models/event_model.dart';
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
            _infoCard(
              context,
              ref,
              event: event,
              name: event.title,
              description: event.description,
              date: event.date,
              time: event.time,
            );
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
                    ref.read(eventListProvider.notifier).toggleCheck(event.id);
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

  void _infoCard(
    BuildContext context,
    WidgetRef ref, {
    required EventModel event,
    required String name,
    required String description,
    required String date,
    required String time,
  }) {
    TextEditingController nameEditing = TextEditingController(text: name);
    TextEditingController descEditing = TextEditingController(
      text: description,
    );
    String dateEditing = date;
    String timeEditing = time;
    showDialog(
      context: context,
      builder: (BuildContext dialogcontext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setPopUpState) {
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
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Event Preview",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPopUpTextField(
                                label: "Event Name",
                                controller: nameEditing,
                                colors: Theme.of(context).colorScheme,
                              ),
                              SizedBox(height: 25),
                              _buildPopUpTextField(
                                label: "Event Description",
                                controller: descEditing,
                                colors: Theme.of(context).colorScheme,
                              ),
                              SizedBox(height: 25),

                              _buildPopUpClickebleField(
                                label: "Event Date",
                                value: dateEditing,
                                icon: Icons.calendar_today_outlined,
                                color: Theme.of(context).colorScheme,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2025),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickedDate != null) {
                                    setPopUpState(() {
                                      dateEditing =
                                          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                                    });
                                  }
                                },
                              ),

                              SizedBox(height: 25),
                              _buildPopUpClickebleField(
                                label: "Event Time",
                                icon: Icons.access_time_rounded,
                                value: timeEditing,
                                color: Theme.of(context).colorScheme,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode:
                                        TimePickerEntryMode.inputOnly,
                                    builder:
                                        (
                                          BuildContext timecontext,
                                          Widget? child,
                                        ) {
                                          return MediaQuery(
                                            data: MediaQuery.of(timecontext)
                                                .copyWith(
                                                  alwaysUse24HourFormat: true,
                                                ),
                                            child: child!,
                                          );
                                        },
                                  );
                                  if (pickedTime != null) {
                                    setPopUpState(() {
                                      timeEditing =
                                          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                                    });
                                    String newTime =
                                        "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                                    ref
                                        .read(eventListProvider.notifier)
                                        .updateEventTime(event.id, newTime);
                                  }
                                },
                              ),

                              SizedBox(height: 25),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          foregroundColor: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(dialogcontext);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 10,
                                          ),
                                          child: Text(
                                            "Cancel",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                            ),
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
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          minimumSize: Size(50, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  24,
                                                ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(dialogcontext);

                                          ref
                                              .read(eventListProvider.notifier)
                                              .updateEvent(
                                                id: event.id,
                                                newTitle: nameEditing.text
                                                    .trim(),
                                                newDesc: descEditing.text
                                                    .trim(),
                                                newDate: dateEditing,
                                                newTime: timeEditing,
                                              );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Event succesfully editted!!',
                                              ),
                                              backgroundColor: Colors.redAccent,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              duration: Duration(seconds: 2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                                                Icons.check_circle_outlined,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 2),
                                              Text(
                                                "Accept",
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
                    IconButton(
                      onPressed: () {
                        Navigator.pop(dialogcontext);
                        ref
                            .read(eventListProvider.notifier)
                            .deleteEvent(event.id);
                      },
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPopUpTextField({
    required String label,
    required TextEditingController controller,
    required ColorScheme colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: colors.tertiary,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopUpClickebleField({
    required String label,
    required String value,
    required IconData icon,
    required ColorScheme color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap, // Tıklandığında takvim veya saati açacak
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: color.surface, // Senin Slate arka plan rengin
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color.tertiary,
                  ),
                ),
                Icon(icon, size: 18, color: color.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
