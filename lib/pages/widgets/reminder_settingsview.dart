import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/providers/notificationOffset_provider.dart';

class ReminderSettings extends ConsumerWidget {
  const ReminderSettings({super.key});

  static const Map<String, int> timeOptions = {
    '1 minute ago': 1,
    '5 minute ago': 5,
    '10 minute ago': 10,
    '1 hour ago': 60,
    '1 day ago': 1440,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOffset = ref.watch(notificationOffsetNotifier);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          DropdownButton<int>(
            value: timeOptions.containsValue(selectedOffset)
                ? selectedOffset
                : timeOptions.values.first,
            icon: const Icon(
              Icons.arrow_drop_down_circle_outlined,
              color: Colors.blue,
            ),
            underline: const SizedBox(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                ref
                    .read(notificationOffsetNotifier.notifier)
                    .updateOffset(newValue);
              }
            },
            items: timeOptions.entries.map((entry) {
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
