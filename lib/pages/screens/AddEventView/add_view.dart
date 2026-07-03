import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reminder/providers/event_provider.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    border: OutlineInputBorder(borderSide: BorderSide.none),

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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    print("BUTONA BASTIN");
                    final fullTime = DateTime.now();
                    final dateNow = DateFormat("dd/MM/yyyy").format(fullTime);
                    final timeNow = DateFormat("HH:mm").format(fullTime);
                    final allText = _textController.text.trim();
                    if (allText.isNotEmpty) {
                      _infoCard(
                        context,
                        name: allText,
                        description: 'Gemini Analyze Here',
                        date: dateNow,
                        time: timeNow,
                      );
                      _textController.clear();
                    } else {
                      print("HATA");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please write something!"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
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

  void _infoCard(
    BuildContext context, {
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
                                            BorderRadiusGeometry.circular(24),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(dialogcontext);

                                      ref
                                          .read(eventListProvider.notifier)
                                          .addEvent(
                                            nameEditing.text.trim(),
                                            descEditing.text.trim(),
                                            dateEditing,
                                            timeEditing,
                                          );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Event succesfully added in your list!!',
                                          ),
                                          backgroundColor: Colors.redAccent,
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
