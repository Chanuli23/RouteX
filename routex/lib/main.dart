import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';
import 'deliveries_screen.dart';
import 'completed_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'contact_admin_screen.dart';
import 'help_support_screen.dart';
import 'splash_screen.dart';
import 'forgot_password_screen.dart';
import 'route_tasks_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    // Web-specific initialization
  } else {
    // Non-web initialization
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RouteX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Set Poppins as the default font
      ),
      debugShowCheckedModeBanner: false, // Remove the debug tag
      initialRoute: '/', // Ensure splash screen is the initial route
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/deliveries': (context) => const DeliveriesScreen(),
        '/completed': (context) => CompletedScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/contact-admin': (context) => const ContactAdminScreen(),
        '/help-support': (context) => const HelpSupportScreen(),
        '/forgot-password': (context) =>
            const ForgotPasswordScreen(), // Add this route
        '/jaffna': (context) => const RouteTasksScreen(routeName: 'Jaffna'),
        '/galle': (context) => const RouteTasksScreen(routeName: 'Galle'),
        '/anuradhapura': (context) =>
            const RouteTasksScreen(routeName: 'Anuradhapura'),
        '/negombo': (context) => const RouteTasksScreen(routeName: 'Negombo'),
        '/colombo': (context) => const RouteTasksScreen(routeName: 'Colombo'),
        '/keells': (context) => const RouteTasksScreen(routeName: 'Keells'),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(); // Show splash screen while waiting for auth state
        } else if (snapshot.hasData) {
          return const DashboardScreen(); // User is logged in, show dashboard
        } else {
          return const LoginScreen(); // User is not logged in, show login screen
        }
      },
    );
  }
}
