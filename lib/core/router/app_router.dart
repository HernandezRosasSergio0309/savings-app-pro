// ignore_for_file: unused_local_variable, dead_null_aware_expression

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaxy_savings/presentation/savings/view/create_target_saving_screen.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/auth/view/complete_profile_screen.dart';
import '../../presentation/auth/view/login_screen.dart';
import '../../presentation/auth/view/register_screen.dart';
import '../../presentation/common_widgets/draggable_glass_toolbar.dart';
import '../../presentation/dashboard/view/dashboard_screen.dart';
import '../../presentation/savings/view/manage_freestyle_saving_screen.dart';
import '../../presentation/savings/view/saving_selection_screen.dart';
import '../../presentation/savings/view/manage_target_saving_screen.dart';
import '../../presentation/settings/view/settings_screen.dart';
import '../../presentation/onboarding/view/onboarding_screen_2.dart';
import '../../presentation/onboarding/view/onboarding_screen_3.dart';
import '../../presentation/splash/view/splash_screen.dart';
import '../../presentation/onboarding/view/onboarding_screen.dart';
import '../../presentation/language/view/language_screen.dart';
import '../../presentation/settings/view/edit_profile_screen.dart';
import '../../presentation/common_widgets/universal_back_button.dart';
import '../../presentation/savings/view/create_freestyle_saving_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'root',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash_screen',
        builder: (context, state) => const SplashScreen(),
      ),
      // SHELL ROUTE PARA EL BOTÓN DE REGRESO GLOBAL
      ShellRoute(
        builder: (context, state, child) =>
            StaticBackButtonWrapper(state: state, child: child),
        routes: [
          GoRoute(
            path: '/onboarding',
            name: 'onboarding_screen',
            pageBuilder: (context, state) =>
                _buildFadeScaleTransition(state, const OnboardingScreen()),
          ),
          GoRoute(
            path: '/language',
            name: 'language_screen',
            pageBuilder: (context, state) =>
                _buildSlideTransition(state, const LanguageScreen()),
          ),
          GoRoute(
            path: '/edit_profile',
            name: 'edit_profile',
            pageBuilder: (context, state) =>
                _buildSlideTransition(state, const EditProfileScreen()),
          ),
          GoRoute(
            path: '/onboarding_2',
            name: 'onboarding_screen_2',
            pageBuilder: (context, state) =>
                _buildSlideTransition(state, const OnboardingScreen2()),
          ),
          GoRoute(
            path: '/onboarding_3',
            name: 'onboarding_screen_3',
            pageBuilder: (context, state) =>
                _buildSlideTransition(state, const OnboardingScreen3()),
          ),
          GoRoute(
            path: '/login',
            name: 'login_screen',
            pageBuilder: (context, state) =>
                _buildFadeScaleTransition(state, const LoginScreen()),
          ),
          GoRoute(
            path: '/register',
            name: 'register_screen',
            pageBuilder: (context, state) =>
                _buildSlideTransition(state, const RegisterScreen()),
          ),
          GoRoute(
            path: '/complete-profile',
            name: 'complete_profile',
            pageBuilder: (context, state) =>
                _buildSlideTransition(state, const CompleteProfileScreen()),
          ),
          GoRoute(
            path: '/create_target_saving',
            name: 'create_target_saving_screen',
            pageBuilder: (context, state) =>
                _buildSlideTransition(state, const CreateTargetSavingScreen()),
          ),
          GoRoute(
            path: '/manage_target_saving',
            name: 'manage_target_saving',
            pageBuilder: (context, state) {
              // Recupera el ID enviado desde la pantalla anterior
              final goalId = state.extra as String;

              // Retornamos la pantalla
              return _buildSlideTransition(
                state,
                ManageTargetSavingScreen(goalId: goalId),
              );
            },
          ),
          GoRoute(
            path: '/create_freestyle_saving',
            name: 'create_freestyle_saving_screen',
            pageBuilder: (context, state) => _buildSlideTransition(
                state, const CreateFreestyleSavingScreen()),
          ),
          GoRoute(
            path: '/manage_freestyle_saving',
            name: 'manage_freestyle_saving',
            pageBuilder: (context, state) {
              final goalId = state.extra as String;
              return _buildSlideTransition(
                state,
                ManageFreestyleSavingScreen(goalId: goalId),
              );
            },
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Rama del Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                name: 'dashboard_screen',
                pageBuilder: (context, state) =>
                    _buildFadeScaleTransition(state, const DashboardScreen()),
              ),
            ],
          ),
          // Rama de Selección de Ahorro
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saving_selection',
                name: 'saving_selection_screen',
                pageBuilder: (context, state) => _buildFadeScaleTransition(
                    state, const SavingSelectionScreen()),
              ),
            ],
          ),
          // Rama de Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings_screen',
                pageBuilder: (context, state) =>
                    _buildFadeScaleTransition(state, const SettingsScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

// FUNCIÓN AUXILIAR PARA TRANSICIONES ANIMADAS
CustomTransitionPage _buildSlideTransition(GoRouterState state, Widget child) {
  // Detectamos si venimos de presionar el botón de retroceso
  final isBack = state.uri.queryParameters['direction'] == 'back';

  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(
        milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Si es 'back', la pantalla entra desde la izquierda (-1.0). Si no, entra desde la derecha (1.0)
      final begin = isBack ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.fastOutSlowIn;

      final slideTween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut));

      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

// FUNCIÓN AUXILIAR PARA TRANSICIÓN DE ESCALA Y DESVANECIMIENTO
CustomTransitionPage _buildFadeScaleTransition(
    GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.fastOutSlowIn;

      final scaleTween =
          Tween<double>(begin: 0.95, end: 1.0).chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut));

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: ScaleTransition(
          scale: animation.drive(scaleTween),
          child: child,
        ),
      );
    },
  );
}

// ENVOLTORIO GLOBAL DEL BOTÓN DE RETROCESO
class StaticBackButtonWrapper extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const StaticBackButtonWrapper({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final location = state.matchedLocation;
    final hideBackButton = ['/onboarding', '/login', '/complete-profile'];
    final showBackButton = !hideBackButton.contains(location);

    final fromParameter = state.uri.queryParameters['from'];

    return Stack(
      children: [
        child,
        Positioned(
          left: 10,
          top: 85,
          child: UniversalBackButton(
            isVisible: showBackButton,
            onTap: () {
              if (fromParameter != null) {
                final safePath = fromParameter.startsWith('/')
                    ? fromParameter
                    : '/$fromParameter';

                // Acoplamos el indicador de retroceso a la URL
                final backPath = safePath.contains('?')
                    ? '$safePath&direction=back'
                    : '$safePath?direction=back';

                context.go(backPath);
              } else if (GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                if (location.contains('onboarding') ||
                    location == '/language' ||
                    location == '/register') {
                  context.go('/onboarding?direction=back');
                } else {
                  context.go('/dashboard');
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

// CLASE DEL CASCARÓN PRINCIPAL CON CANDADO DE NAVEGACIÓN
class MainShellScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int toolbarIndex = navigationShell.currentIndex;

    // Escuchamos globalmente si el Dashboard está en modo edición
    final bool isEditing = ref.watch(dashboard_edit_mode_provider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          navigationShell,
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: SafeArea(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isEditing ? 0.4 : 1.0,
                child: AbsorbPointer(
                  absorbing: isEditing,
                  child: DraggableGlassToolbar(
                    initialIndex: toolbarIndex,
                    onTabDropped: (index) {
                      navigationShell.goBranch(index);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
