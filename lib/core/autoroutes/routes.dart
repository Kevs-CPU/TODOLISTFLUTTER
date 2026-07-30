// lib/core/autoroutes/routes.dart

import 'package:auto_route/auto_route.dart';

import 'package:todovalidate/app/pages/auth/widgets/login_widget.dart';
import 'package:todovalidate/app/pages/dashboard/dashboard_page.dart';
import 'package:todovalidate/core/autoroutes/authguard.dart';

part 'routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Widget|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: DashboardRoute.page,
          path: '/dashboard',
          guards: [authGuard],
        ),
        AutoRoute(
          page: DashboardRoute.page,
          path: '/',
          guards: [authGuard],
        ),
      ];
}