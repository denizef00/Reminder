import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationOffsetNotifier extends StateNotifier<int> {
  NotificationOffsetNotifier() : super(1) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    state = prefs.getInt('notification_offset') ?? 1;
  }

  Future<void> updateOffset(int newValue) async {
    state = newValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_offset', newValue);
  }
}

final notificationOffsetNotifier =
    StateNotifierProvider<NotificationOffsetNotifier, int>((ref) {
      return NotificationOffsetNotifier();
    });
