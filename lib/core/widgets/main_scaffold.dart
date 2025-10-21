import 'package:flutter/material.dart';
import '../../features/home/presentation/screens/dashboard_screen.dart';
import '../../features/events/presentation/screens/events_screen.dart';

/// Main application scaffold with bottom navigation bar
///
/// Provides persistent bottom navigation across 5 main app sections:
/// - Home: Dashboard with activity overview
/// - Societies: Golf society management
/// - Events: Event scheduling and management
/// - Leaderboard: Rankings and statistics
/// - Profile: User profile and settings
///
/// Uses IndexedStack to preserve state across tab switches.
/// Each tab has its own Navigator to maintain independent navigation stacks.
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  // Current selected tab index (0-4)
  int _currentIndex = 0;

  // Navigation keys for each tab's Navigator
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _societiesNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _eventsNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _leaderboardNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _profileNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Handle back button: pop current tab's navigator stack first
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        final currentNavigator = _getCurrentNavigator();
        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeNavigator(),
            _buildSocietiesNavigator(),
            _buildEventsNavigator(),
            _buildLeaderboardNavigator(),
            _buildProfileNavigator(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: 'Societies',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  /// Handle tab tap - switch to selected tab
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Get the current tab's navigator
  NavigatorState? _getCurrentNavigator() {
    switch (_currentIndex) {
      case 0:
        return _homeNavigatorKey.currentState;
      case 1:
        return _societiesNavigatorKey.currentState;
      case 2:
        return _eventsNavigatorKey.currentState;
      case 3:
        return _leaderboardNavigatorKey.currentState;
      case 4:
        return _profileNavigatorKey.currentState;
      default:
        return null;
    }
  }

  /// Build Home tab navigator
  Widget _buildHomeNavigator() {
    return Navigator(
      key: _homeNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const DashboardScreen());
      },
    );
  }

  /// Build Societies tab navigator
  Widget _buildSocietiesNavigator() {
    return Navigator(
      key: _societiesNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) =>
              _buildPlaceholderScreen('Societies', Icons.groups),
        );
      },
    );
  }

  /// Build Events tab navigator
  Widget _buildEventsNavigator() {
    return Navigator(
      key: _eventsNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const EventsScreen());
      },
    );
  }

  /// Build Leaderboard tab navigator
  Widget _buildLeaderboardNavigator() {
    return Navigator(
      key: _leaderboardNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) =>
              _buildPlaceholderScreen('Leaderboard', Icons.leaderboard),
        );
      },
    );
  }

  /// Build Profile tab navigator
  Widget _buildProfileNavigator() {
    return Navigator(
      key: _profileNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) =>
              _buildPlaceholderScreen('Profile', Icons.person),
        );
      },
    );
  }

  /// Temporary placeholder screen for each tab
  /// Will be replaced with actual screens in subsequent tasks
  Widget _buildPlaceholderScreen(String title, IconData icon) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64),
            const SizedBox(height: 16),
            Text(
              '$title Tab',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Coming soon'),
          ],
        ),
      ),
    );
  }
}
