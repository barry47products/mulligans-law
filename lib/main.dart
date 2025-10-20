import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import 'core/theme/app_spacing.dart';
import 'core/widgets/app_card.dart';
import 'core/widgets/app_button.dart';
import 'core/widgets/app_text_field.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/members/data/repositories/member_repository_impl.dart';
import 'features/auth/presentation/screens/screens.dart';
import 'features/societies/data/repositories/society_repository_impl.dart';
import 'features/societies/domain/entities/society.dart';
import 'features/societies/domain/usecases/create_society.dart';
import 'features/societies/domain/usecases/get_user_societies.dart';
import 'features/societies/domain/usecases/update_society.dart';
import 'features/societies/presentation/bloc/society_bloc.dart';
import 'features/societies/presentation/screens/society_dashboard_screen.dart';
import 'features/societies/presentation/screens/society_form_screen.dart';
import 'features/societies/presentation/screens/society_list_screen.dart';
import 'features/societies/presentation/screens/society_members_screen.dart';
import 'features/members/domain/usecases/get_member_count.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
    debug: SupabaseConfig.enableDebugLogging,
  );

  runApp(const MulligansLawApp());
}

class MulligansLawApp extends StatelessWidget {
  const MulligansLawApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create Supabase client
    final supabaseClient = Supabase.instance.client;

    // Create auth repository and use cases
    final authRepository = AuthRepositoryImpl(supabase: supabaseClient);
    final signInUseCase = SignIn(authRepository);
    final signOutUseCase = SignOut(authRepository);
    final getCurrentUserUseCase = GetCurrentUser(authRepository);

    // Create member repository
    final memberRepository = MemberRepositoryImpl(supabase: supabaseClient);

    // Create SignUp use case (requires both auth and member repositories)
    final signUpUseCase = SignUp(authRepository, memberRepository);

    // Create society repository and use cases
    final societyRepository = SocietyRepositoryImpl(supabase: supabaseClient);
    // CreateSociety requires both society and member repositories
    final createSocietyUseCase = CreateSociety(
      societyRepository,
      memberRepository,
    );
    final getUserSocietiesUseCase = GetUserSocieties(societyRepository);
    final updateSocietyUseCase = UpdateSociety(societyRepository);

    // Create member use cases
    final getMemberCountUseCase = GetMemberCount(memberRepository);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GetMemberCount>.value(value: getMemberCountUseCase),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              signIn: signInUseCase,
              signUp: signUpUseCase,
              signOut: signOutUseCase,
              getCurrentUser: getCurrentUserUseCase,
              authRepository: authRepository,
            )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => SocietyBloc(
              createSociety: createSocietyUseCase,
              getUserSocieties: getUserSocietiesUseCase,
              updateSociety: updateSocietyUseCase,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Mulligans Law',
          theme: AppTheme.lightTheme(),
          debugShowCheckedModeBanner: false,
          home: const AuthGate(),
          routes: {
            WelcomeScreen.routeName: (context) => const WelcomeScreen(),
            SignInScreen.routeName: (context) => const SignInScreen(),
            SignUpScreen.routeName: (context) => const SignUpScreen(),
            ForgotPasswordScreen.routeName: (context) =>
                const ForgotPasswordScreen(),
            VerifyEmailScreen.routeName: (context) {
              // Extract email from route arguments
              final email =
                  ModalRoute.of(context)?.settings.arguments as String? ??
                  'your@email.com';
              return VerifyEmailScreen(email: email);
            },
            '/home': (context) => const HomeScreen(),
            '/societies': (context) => const SocietyListScreen(),
            '/societies/create': (context) => const SocietyFormScreen(),
            '/societies/edit': (context) {
              final society = ModalRoute.of(context)?.settings.arguments;
              return SocietyFormScreen(society: society as Society?);
            },
          },
          onGenerateRoute: (settings) {
            // Handle dynamic routes like /societies/:id/dashboard
            if (settings.name?.startsWith('/societies/') == true &&
                settings.name?.endsWith('/dashboard') == true) {
              final society = settings.arguments as Society?;
              if (society != null) {
                return MaterialPageRoute(
                  builder: (context) => SocietyDashboardScreen(
                    society: society,
                    getMemberCount: getMemberCountUseCase,
                  ),
                );
              }
            }
            // Handle /societies/:id/members route
            if (settings.name?.startsWith('/societies/') == true &&
                settings.name?.endsWith('/members') == true) {
              final society = settings.arguments as Society?;
              if (society != null) {
                return MaterialPageRoute(
                  builder: (context) => SocietyMembersScreen(society: society),
                );
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}

/// Authentication gate that routes to appropriate screen based on auth state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          // Show loading indicator while checking auth status
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthAuthenticated) {
          // User is authenticated, show home screen
          return const HomeScreen();
        } else {
          // User is not authenticated, show welcome screen
          return const WelcomeScreen();
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mulligans Law'),
        actions: [
          // Temporary sign out button for testing
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.space6),

            // Welcome Section
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    'Welcome to Mulligans Law',
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    'Golf Society Score Tracking',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space8),

            // Quick Actions Section
            Text(
              'Quick Actions',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                    label: 'My Societies',
                    onPressed: () {
                      Navigator.of(context).pushNamed('/societies');
                    },
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  AppButton(
                    label: 'Start a Round',
                    onPressed: () {
                      // TODO: Navigate to round creation
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space8),

            // Design System Demo Section
            Text(
              'Design System Demo',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),

            // Color Palette Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Color Palette', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.space3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ColorSwatch(color: AppColors.primary, label: 'Primary'),
                      _ColorSwatch(color: AppColors.success, label: 'Success'),
                      _ColorSwatch(color: AppColors.warning, label: 'Warning'),
                      _ColorSwatch(color: AppColors.error, label: 'Error'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space4),

            // Golf Scores Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Golf Score Colors',
                    style: AppTypography.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ColorSwatch(color: AppColors.eagle, label: 'Eagle'),
                      _ColorSwatch(color: AppColors.birdie, label: 'Birdie'),
                      _ColorSwatch(color: AppColors.par, label: 'Par'),
                      _ColorSwatch(color: AppColors.bogey, label: 'Bogey'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space4),

            // Typography Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Typography', style: AppTypography.headlineLarge),
                  const SizedBox(height: AppSpacing.space3),
                  Text('Headline Medium', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    'Body Large - Regular paragraph text with comfortable reading size',
                    style: AppTypography.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    'Body Medium - Smaller text for less emphasis',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    'Label Large - For buttons and inputs',
                    style: AppTypography.labelLarge,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space4),

            // Form Components Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Form Components', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.space4),
                  const AppTextField(
                    label: 'Player Name',
                    hint: 'Enter your name',
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  const AppTextField(
                    label: 'Handicap',
                    hint: 'Enter your handicap',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  AppButton(
                    label: 'Start Round',
                    onPressed: () {
                      // Button action
                    },
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  AppButton(
                    label: 'Loading State',
                    isLoading: true,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space8),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorSwatch({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300, width: 1),
          ),
        ),
        const SizedBox(height: AppSpacing.space1),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
