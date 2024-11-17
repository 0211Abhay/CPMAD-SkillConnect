import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:skillconnect_app/firebase_options.dart';
import 'package:skillconnect_app/screens/home_page.dart';
import 'package:skillconnect_app/screens/register_page.dart';
import 'package:skillconnect_app/screens/splash_screen.dart';
import 'screens/login_page.dart';
import './screens/splash_screen.dart'; // Import SplashScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure Firebase is initialized with the correct options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Pass the correct platform-specific options
  );
  await GetStorage.init(); // Initialize GetStorage

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillConnect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Use AuthStateHandler as the home screen
      routes: {
        '/auth' :(context) => const AuthStateHandler(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Wait for Firebase to initialize before showing splash screen
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show splash screen while Firebase is initializing
          return const SplashScreen();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Check authentication state
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data != null) {
                return  HomePage();  // Navigate to HomePage if logged in
              } else {
                return const LoginPage(); // Navigate to LoginPage if not logged in
              }
            },
          );
        }
      },
    );
  }
}
