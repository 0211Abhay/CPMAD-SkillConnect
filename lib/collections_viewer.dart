import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillconnect_app/screens/login_page.dart';  // Import your LoginPage for navigation

class CollectionsViewer extends StatefulWidget {
  @override
  _CollectionsViewerState createState() => _CollectionsViewerState();
}

class _CollectionsViewerState extends State<CollectionsViewer> {
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();  // Sign out the user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),  // Navigate to LoginPage
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
        title: Text('Firestore Collection Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,  // Trigger sign out
          ),
        ],
      ),
      body: Center(
        child: Text('Collections Viewer'),
      ),
    );
  }
}
