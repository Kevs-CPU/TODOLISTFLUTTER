// lib/core/autoroutes/authguard.dart

import 'package:auto_route/auto_route.dart';
import 'package:todovalidate/app/providers/auth_provider.dart';
import 'package:todovalidate/core/autoroutes/routes.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthProvider authProvider;

  AuthGuard({required this.authProvider});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    
    if (authProvider.loading) {
      // Wait for auth to finish loading
      // You can also add a timer to prevent infinite loading
      Future.delayed(const Duration(milliseconds: 500), () {
        if (authProvider.isAuthenticated) {
          resolver.next(true);
        } else {
          resolver.next(false);
          router.replace(const LoginRoute());
        }
      });
      return;
    }

    if (authProvider.isAuthenticated) {
      resolver.next(true);
    } else {
      // Not authenticated - redirect to login
      resolver.next(false);
      router.replace(const LoginRoute());
    }
  }
}