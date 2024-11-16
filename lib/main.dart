import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skillconnect_app/collections_viewer.dart';
import 'package:skillconnect_app/firebase_options.dart';

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
        '/collectionsViewer': (context) => CollectionsViewer(),
        '/login' :(context) => LoginPage(),
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return CollectionsViewer();
        } else {
          return LoginPage();
        }
      },

    );
  }
}
