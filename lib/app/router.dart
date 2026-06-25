import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder/pages/screens/AddEventView/add_view.dart';
import 'package:reminder/pages/screens/CalendarView/calendar_view.dart';
import 'package:reminder/pages/screens/ListView/list_view.dart';

import 'package:reminder/pages/main_view.dart';

final _rooterKey = GlobalKey<NavigatorState>();

class AppRoutes {
  AppRoutes._();
  static const String listview = "/listview";
  static const String addview = "/";
  static const String calendarview = "/calendar";
}

final router = GoRouter(
  navigatorKey: _rooterKey,
  initialLocation: AppRoutes.addview,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.listview,
              builder: (context, state) => ListPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.addview,
              builder: (context, state) => AddView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.calendarview,
              builder: (context, state) => CalendarView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
