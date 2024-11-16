import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillconnect_app/screens/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Sign out function
  Future<void> _signOut(BuildContext context) async {
    try { 
      await FirebaseAuth.instance.signOut();  // Sign out the user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),  // Navigate to LoginPage
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),  // Logout icon
            onPressed: () => _signOut(context),  // Trigger sign out
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Home Page'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signOut(context),  // Button to log out
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Customize as needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
