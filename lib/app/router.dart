import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/assistant_chat/presentation/assistant_chat_page.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/auth_page.dart';
import '../features/leaderboard/presentation/leaderboard_page.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/quest/presentation/quest_completion_page.dart';
import '../features/quest/presentation/quest_home_page.dart';
import '../features/quest/presentation/quest_task_page.dart';
import '../features/settings/presentation/settings_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth',
    refreshListenable: GoRouterRefreshStream(ref.watch(authStateProvider.stream)),
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider).value;
      final loggingIn = state.subloc == '/auth';
      if (auth == null && !loggingIn) return '/auth';
      if (auth != null && loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) => HomeShell(shell: navShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (context, state) => const QuestHomePage(), routes: [
              GoRoute(path: 'quest/task', builder: (context, state) => const QuestTaskPage()),
              GoRoute(path: 'quest/completed', builder: (context, state) => const QuestCompletionPage()),
            ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/leaderboard', builder: (context, state) => const LeaderboardPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/assistant', builder: (context, state) => const AssistantChatPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
          ]),
        ],
      ),
    ],
  );
});

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: shell.goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Assistant'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
