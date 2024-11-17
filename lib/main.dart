import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:skillconnect_app/firebase_options.dart';
import 'package:skillconnect_app/screens/home_page.dart';
import 'package:skillconnect_app/screens/register_page.dart';

import 'screens/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure Firebase is initialized with the correct options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Pass the correct platform-specific options
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthStateHandler(),
      routes: {
        '/login' :(context) => LoginPage(),
        
        '/register' :(context) => RegisterPage(),
      },
    );  
  }
}

class AuthStateHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
