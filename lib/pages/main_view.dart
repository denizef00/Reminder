import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder/providers/theme_provider.dart';

class MainScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _appBarView(context, ref),
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(color: Theme.of(context).colorScheme.primary);
            }
            return TextStyle(color: Color(0xFFB5C4C7));
          }),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            _menuItem(
              context,
              index: 0,
              currentIndex: navigationShell.currentIndex,
              label: "List View",
              icon: Icons.list,
            ),
            _menuItem(
              context,
              index: 1,
              currentIndex: navigationShell.currentIndex,
              label: "Add Event",
              icon: Icons.add,
            ),
            _menuItem(
              context,
              index: 2,
              currentIndex: navigationShell.currentIndex,
              label: "Calendar",
              icon: Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required int index,
    required int currentIndex,
    required String label,
    required IconData icon,
  }) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: currentIndex == index
            ? Theme.of(context).colorScheme.primary
            : Color(0xFFB5C4C7),
      ),
      label: label,
    );
  }

  AppBar _appBarView(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(
        "Reminder",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            _settingsCard(context, ref);
          },
        ),
      ],
    );
  }

  Switch _themeMode(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeProvider);
    final currentThemeMode = themeAsync.value ?? ThemeMode.light;
    return Switch(
      value: currentThemeMode == ThemeMode.light,
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return Icon(Icons.light_mode_outlined, color: Colors.orange);
        }
        return Icon(
          Icons.dark_mode_outlined,
          color: Theme.of(context).colorScheme.primary,
        );
      }),
      onChanged: (newValue) => ref.read(themeProvider.notifier).toggleTheme(),
    );
  }

  void _settingsCard(BuildContext context, WidgetRef ref) {
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
                          children: [
                            Text('Theme Mode :'),
                            SizedBox(width: 100),
                            _themeMode(context, ref),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Notification Time : '),
                            SizedBox(width: 50),

                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Set Time"),
                            ),
                          ],
                        ),
                      ],
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
}
