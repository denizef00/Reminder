import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/pages/widgets/reminder_settingsview.dart';
import 'package:reminder/providers/event_provider.dart';
import 'package:reminder/providers/notificationOffset_provider.dart';
import 'package:reminder/services/notification_services.dart';

class InfoCard {
  static void show(
    BuildContext context,
    WidgetRef ref, {
    required String id,
    required String name,
    required String description,
    required String date,
    required String time,
    required VoidCallback onCheckPressed,
    required VoidCallback onDeletePressed,
    required VoidCallback onConfirm,
    required String buttonName1,
    required String buttonName2,
    required bool edittingMode,
  }) {
    final offsetMinute = ref.read(notificationOffsetNotifier);
    final selectedText = ReminderSettings.timeOptions.entries
        .firstWhere(
          (entry) => entry.value == offsetMinute,
          orElse: () => const MapEntry('Bilinmeyen Süre', 0),
        )
        .key;
    TextEditingController nameEditing = TextEditingController(text: name);
    TextEditingController descEditing = TextEditingController(
      text: description,
    );
    String dateEditing = date;
    String timeEditing = time;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setPopUpState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.symmetric(horizontal: 15),
              backgroundColor: Colors.transparent,
              elevation: 8,
              content: SingleChildScrollView(
                child: Container(
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
                                      locale: const Locale('en', 'GB'),
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
                                    TimeOfDay?
                                    pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.inputOnly,
                                      builder:
                                          (
                                            BuildContext timecontext,
                                            Widget? child,
                                          ) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                textSelectionTheme:
                                                    TextSelectionThemeData(
                                                      cursorColor: Theme.of(
                                                        context,
                                                      ).colorScheme.tertiary,
                                                      selectionColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiary
                                                              .withOpacity(0.3),
                                                      selectionHandleColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiary,
                                                    ),

                                                colorScheme: Theme.of(context)
                                                    .colorScheme
                                                    .copyWith(
                                                      onSurface: Theme.of(
                                                        context,
                                                      ).colorScheme.tertiary,
                                                    ),
                                              ),
                                              child: MediaQuery(
                                                data: MediaQuery.of(timecontext)
                                                    .copyWith(
                                                      alwaysUse24HourFormat:
                                                          true,
                                                    ),
                                                child: child!,
                                              ),
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
                                          .updateEventTime(id, newTime);
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
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              buttonName1,
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
                                              vertical: 5,
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
                                            Navigator.pop(context);
                                            edittingMode
                                                ? _updateEvent(
                                                    ref,
                                                    id,
                                                    nameEditing,
                                                    descEditing,
                                                    dateEditing,
                                                    timeEditing,
                                                  )
                                                : _newEvent(
                                                    ref,
                                                    id,
                                                    nameEditing,
                                                    descEditing,
                                                    dateEditing,
                                                    timeEditing,
                                                  );
                                            NotificationServices()
                                                .scheduleReminder(
                                                  ref,
                                                  id: 0,
                                                  title: nameEditing.text
                                                      .trim(),
                                                  dateStr: dateEditing,
                                                  timeStr: timeEditing,
                                                );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Event succesfully editted!!',
                                                ),
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.error,
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
                                                  buttonName2,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      selectedText,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.tertiary,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.timelapse),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (edittingMode)
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onDeletePressed();
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                          color: Theme.of(context).colorScheme.error,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void _updateEvent(
  WidgetRef ref,
  String id,
  TextEditingController nameEditing,
  TextEditingController descEditing,
  String dateEditing,
  String timeEditing,
) {
  ref
      .read(eventListProvider.notifier)
      .updateEvent(
        id: id,
        newTitle: nameEditing.text.trim(),
        newDesc: descEditing.text.trim(),
        newDate: dateEditing,
        newTime: timeEditing,
      );
}

void _newEvent(
  WidgetRef ref,
  String id,
  TextEditingController name,
  TextEditingController desc,
  String date,
  String time,
) {
  ref
      .read(eventListProvider.notifier)
      .addEvent(id, name.text.trim(), desc.text.trim(), date, time);
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
              Icon(icon, size: 18, color: color.primary), // Senin Indigo ikonun
            ],
          ),
        ),
      ],
    ),
  );
}
