import 'package:flutter/material.dart';

class ReminderSettings extends StatefulWidget {
  final ValueChanged<int> onTimeSelected;
  final int initialValue;

  const ReminderSettings({
    Key? key,
    required this.onTimeSelected,
    this.initialValue = 15, // Varsayılan değer yine 15
  }) : super(key: key);

  @override
  State<ReminderSettings> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends State<ReminderSettings> {
  int _selectedOffset = 1;
  final Map<String, int> _timeOptions = {
    '1 minute ago ': 1,
    '5 minute ago ': 5,
    '10 minute ago ': 10,
    '1 hour ago ': 60,
    '1 day ago ': 1440,
  };
  @override
  void initState() {
    super.initState();
    _selectedOffset = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          DropdownButton<int>(
            value: _selectedOffset,
            icon: Icon(
              Icons.arrow_drop_down_circle_outlined,
              color: Colors.blue,
            ),
            underline: SizedBox(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedOffset = newValue;
                });
                print("Seçilen Süre (Dakika): $_selectedOffset");
              }
            },
            items: _timeOptions.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.value,
                child: Text(entry.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
