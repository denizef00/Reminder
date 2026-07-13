import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/providers/event_provider.dart';
import 'package:reminder/providers/gemini_provider.dart';
import 'package:reminder/services/notification_services.dart';

class AddView extends ConsumerStatefulWidget {
  const AddView({super.key});

  @override
  ConsumerState<AddView> createState() => _AddViewState();
}

class _AddViewState extends ConsumerState<AddView> {
  final TextEditingController _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isGeminiLoading = ref.watch(geminiLoadingProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: isGeminiLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Gemini Analyze Your Text",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onSecondary,
                    ),
                    onPressed: () {
                      ref
                          .read(geminiLoadingProvider.notifier)
                          .cancelOperation();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Operation canceled by user!'),
                        ),
                      );
                    },
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 114,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          child: TextField(
                            controller: _textController,
                            maxLines: 9,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),

                              hintText: "There's a meeting tomorrow at 8:40.",
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.tertiary.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              print("BUTONA BASTIN");
                              final String userText = _textController.text
                                  .trim();

                              if (userText.isNotEmpty) {
                                _infoCard(
                                  context,
                                  name: userText,
                                  description: "Test Desc",
                                  date:
                                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                  time:
                                      "${DateTime.now().hour}:${DateTime.now().minute}",
                                  onConfrim: ((name, desc, date, time) {
                                    ref
                                        .read(eventListProvider.notifier)
                                        .addEvent(name, desc, date, time);
                                    _textController.clear();
                                  }),
                                );
                              }
                              /*
                              if (userText.isNotEmpty) {
                                ref
                                    .read(geminiLoadingProvider.notifier)
                                    .setLoading(true);

                                final geminiService = ref.read(
                                  geminiServiceProvider,
                                );
                                final Map<String, dynamic>? eventData =
                                    await geminiService.parseTexttoEvent(
                                      userText,
                                    );

                                ref
                                    .read(geminiLoadingProvider.notifier)
                                    .setLoading(false);

                                if (eventData != null) {

                                  _infoCard(
                                    context,
                                    name: eventData['eventName'] ?? 'New Event',
                                    description:
                                        eventData['description'] ?? '--',
                                    date:
                                        eventData['date'] ??
                                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                    time:
                                        eventData['time'] ??
                                        '${DateTime.now().hour}:${DateTime.now().minute}',
                                    onConfrim: (name, desc, date, time) {
                                      ref
                                          .read(eventListProvider.notifier)
                                          .addEvent(name, desc, date, time);

                                      _textController.clear();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Event successfully added to calendar!!',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Gemini could not parse the text.Please try again!!',
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please write something!!"),
                                  ),
                                );
                              }*/
                            },
                            child: const Text(
                              "ADD EVENT",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            NotificationServices().showNotification(
                              id: 0,
                              title: "Test",
                              body: "TEST",
                            );
                          },
                          child: Text("Send Notification"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _infoCard(
    BuildContext context, {
    required String name,
    required String description,
    required String date,
    required String time,
    required Function(String name, String desc, String date, String time)
    onConfrim,
  }) {
    TextEditingController nameEditing = TextEditingController(text: name);
    TextEditingController descEditing = TextEditingController(
      text: description,
    );
    String dateEditing = date;
    String timeEditing = time;

    showDialog(
      context: context,
      barrierDismissible: true,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Event Preview",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
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
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                builder:
                                    (BuildContext timecontext, Widget? child) {
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
                                                selectionHandleColor: Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
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
                                                alwaysUse24HourFormat: true,
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
                                setState(() {});
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
                                            BorderRadiusGeometry.circular(24),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(dialogcontext);

                                      onConfrim(
                                        nameEditing.text.trim(),
                                        descEditing.text.trim(),
                                        dateEditing,
                                        timeEditing,
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
      onTap: onTap,
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
              color: color.surface,
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
