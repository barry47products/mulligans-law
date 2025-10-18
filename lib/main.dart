import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import 'core/theme/app_spacing.dart';
import 'core/widgets/app_card.dart';
import 'core/widgets/app_button.dart';
import 'core/widgets/app_text_field.dart';
import 'features/auth/presentation/screens/screens.dart';

void main() {
  runApp(const MulligansLawApp());
}

class MulligansLawApp extends StatelessWidget {
  const MulligansLawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mulligans Law',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.routeName,
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
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mulligans Law')),
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
                  Icon(Icons.golf_course, size: 80, color: AppColors.primary),
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
