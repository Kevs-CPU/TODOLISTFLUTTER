import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todovalidate/app/providers/auth_provider.dart';
import 'package:todovalidate/app/providers/task_provider.dart';
import 'package:todovalidate/core/theme/theme.dart';
import 'package:todovalidate/core/injection_container.dart';  
import 'package:todovalidate/core/autoroutes/routes.dart';
import 'package:todovalidate/core/autoroutes/authguard.dart';
import 'package:todovalidate/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Step 1: Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully!');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  //  Step 2: Initialize dependencies FIRST
  await initializeDependencies();
  debugPrint(' Dependencies initialized successfully!');

  //  Step 3: Create AuthProvider
  final authProvider = AuthProvider();
  
  //  Step 4: Initialize auth state observer
  authProvider.initialize();
  debugPrint(' AuthProvider initialized successfully!');

  final authGuard = AuthGuard(authProvider: authProvider);
  final appRouter = AppRouter(authGuard: authGuard);

  runApp(MyApp(
    authProvider: authProvider,
    appRouter: appRouter,
  ));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final AppRouter appRouter;

  const MyApp({
    super.key,
    required this.authProvider,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
        ),
        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'TodoValidate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter.config(),
      ),
    );
  }
}