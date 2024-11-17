import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_page.dart'; // Import the edit profile page

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _currentUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Get the currently signed-in user
      _currentUser = FirebaseAuth.instance.currentUser!;

      // Fetch user details from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_currentUser.uid)
          .get();
      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch profile data: $e')),
      );
    }
  }

  // Navigate to the Edit Profile Page and reload data when returning
  Future<void> _navigateToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(),
      ),
    );
    _fetchUserData(); // Reload data when returning from EditProfilePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('No profile data found.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person, size: 40),
                        title: Text(
                          _userData!['first_name'] ?? 'First Name',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(_userData!['last_name'] ?? 'Last Name'),
                      ),
                      const SizedBox(height: 16),
                      Text('Email: ${_userData!['email'] ?? 'Not provided'}'),
                      const SizedBox(height: 8),
                      Text('Phone: ${_userData!['phone'] ?? 'Not provided'}'),
                      const SizedBox(height: 8),
                      Text(
                        'Skills: ${(_userData!['skills'] as List<dynamic>?)?.join(', ') ?? 'No skills added.'}',
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _navigateToEditProfile, // Use the new method
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Edit Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
