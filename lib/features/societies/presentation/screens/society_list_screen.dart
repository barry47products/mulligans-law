import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/society_bloc.dart';
import '../bloc/society_event.dart';
import '../bloc/society_state.dart';
import '../widgets/discover_societies_tab.dart';
import '../widgets/my_societies_tab.dart';

/// Screen displaying list of user's societies with tabs for My Societies and Discover
class SocietyListScreen extends StatefulWidget {
  const SocietyListScreen({super.key});

  static const String routeName = '/societies';

  @override
  State<SocietyListScreen> createState() => _SocietyListScreenState();
}

class _SocietyListScreenState extends State<SocietyListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load user's societies on init
    context.read<SocietyBloc>().add(const SocietyLoadRequested());

    // Listen to tab changes to load public societies when Discover tab is selected
    _tabController.addListener(() {
      if (_tabController.index == 1 && !_tabController.indexIsChanging) {
        // Discover tab selected - load public societies
        context.read<SocietyBloc>().add(const SocietyLoadPublicRequested());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Societies'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'My Societies'),
            Tab(text: 'Discover'),
          ],
        ),
      ),
      body: BlocListener<SocietyBloc, SocietyState>(
        listener: (context, state) {
          if (state is SocietyOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: const [MySocietiesTab(), DiscoverSocietiesTab()],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _navigateToCreateSociety,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  void _navigateToCreateSociety() {
    // Navigate to create form (relative path within Societies tab)
    Navigator.pushNamed(context, '/create');
  }
}
