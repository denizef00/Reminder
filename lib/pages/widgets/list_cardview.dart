import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reminder/providers/event_provider.dart';

class ListCardview extends ConsumerWidget {
  final String id;
  final String name;
  final String description;
  final String date;
  final String time;
  final bool isCompleted;
  final VoidCallback onCheckPressed;
  final VoidCallback onDeletePressed;

  const ListCardview({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    this.isCompleted = false,
    required this.onCheckPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullTime = DateTime.now();
    final dateNow = DateFormat("dd/MM/yyyy").format(fullTime);
    final timeNow = DateFormat("HH:mm").format(fullTime);
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GestureDetector(
          onTap: () {
            _infoCard(
              context,
              ref,
              name: name,
              desciptiom: description,
              date: dateNow,
              time: timeNow,
            );
          },
          child: Container(
            height: 100,
            width: 520,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: !isCompleted
                  ? _listCardWidget(
                      context,
                      event: name,
                      date: dateNow,
                      time: timeNow,
                    )
                  : _completeCardWidget(
                      context,
                      event: name,
                      date: dateNow,
                      time: timeNow,
                    ),
            ),
          ),
        ),
        IconButton(
          onPressed: onCheckPressed,
          icon: const Icon(Icons.check_circle_outline_rounded),
          color: !isCompleted
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurface,
          iconSize: 30,
        ),
      ],
    );
  }

  Column _completeCardWidget(
    BuildContext context, {
    required String event,
    required String date,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        _completeNameWidget(context, event: event),
        SizedBox(height: 15),
        _completeTimeWidget(context, date: date, time: time),
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

  Widget _completeNameWidget(BuildContext context, {required String event}) {
    return Row(
      children: [
        SizedBox(width: 27),
        Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(
              context,
            ).colorScheme.tertiary.withOpacity(0.4), // %40 görünürlük (soluk)

            decoration: TextDecoration.lineThrough,

            decorationColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.5), // Çizgi rengi
            decorationThickness: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _completeTimeWidget(
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
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
            fontSize: 16,
          ),
        ),
        SizedBox(width: 10),
        Text(
          " • ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
          ),
        ),
        SizedBox(width: 10),

        Text(
          time,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _infoCard(
    BuildContext context,
    WidgetRef ref, {
    required String name,
    required String desciptiom,
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
                                  );
                                  if (pickedTime != null) {
                                    setPopUpState(() {
                                      timeEditing =
                                          "${pickedTime.hour}:${pickedTime.minute}";
                                    });
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
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 2),
                                              Text(
                                                "Cancel",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
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
                                                id: id,
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
                        onDeletePressed();
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
                Icon(
                  icon,
                  size: 18,
                  color: color.primary,
                ), // Senin Indigo ikonun
              ],
            ),
          ),
        ],
      ),
    );
  }
}
