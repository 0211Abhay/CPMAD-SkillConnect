import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skillconnect_app/screens/home_page.dart';

import '../screens/login_page.dart';

class UserSkillsPage extends StatefulWidget {
  final String uid;
  final String phone;

  const UserSkillsPage({Key? key, required this.uid, required this.phone})
      : super(key: key);

  @override
  _UserSkillsPageState createState() => _UserSkillsPageState();
}

class _UserSkillsPageState extends State<UserSkillsPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // List of predefined skills
  final List<String> skills = [
    'HTML', 'CSS', 'Flutter', 'Blockchain', 'Machine Learning (ML)',
    'Android Development', 'Java', 'JavaScript', 'Python', 'C#', 'Go',
    'Ruby', 'Cloud Computing', 'Docker', 'Kubernetes', 'DevOps',
    'AI/Deep Learning', 'ReactJS', 'NodeJS', 'SQL/Database Management',
    'Cybersecurity', 'Big Data', 'Swift (iOS Development)', 'TypeScript',
    'Firebase', '3D Modeling', '3D Designing', 'Game Development (Unity/Unreal Engine)',
    'AR/VR Development', 'UI/UX Design', 'Data Science', 'Robotics',
    'Embedded Systems', 'Digital Marketing & SEO', 'Computer Vision',
  ];

  final List<String> _selectedSkills = [];
  String _searchQuery = '';
  final box = GetStorage(); // Instance of GetStorage

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // Fetch user data for pre-fill
  Future<void> _fetchUserData() async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(widget.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          _firstNameController.text = data['first_name'] ?? '';
          _lastNameController.text = data['last_name'] ?? '';
          _selectedSkills.addAll(List<String>.from(data['skills'] ?? []));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  // Save skills to Firestore and local storage
  Future<void> _saveSkills() async {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First Name and Last Name cannot be empty')),
      );
      return;
    }

    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one skill')),
      );
      return;
    }

    try {
      // Update Firestore
      await FirebaseFirestore.instance.collection('Users').doc(widget.uid).update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'skills': _selectedSkills, // Skills saved as an array
        'email': FirebaseAuth.instance.currentUser!.email,
        'phone': widget.phone,
      });

      // Save locally using GetStorage
      box.write('first_name', _firstNameController.text);
      box.write('last_name', _lastNameController.text);
      box.write('skills', _selectedSkills);

      // Navigate to the login page after registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save skills: $e')),
      );
    }
  }

  // Handle skill search
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Returning false prevents back navigation
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Enter Your Skills')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('First Name:'),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter First Name',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Last Name:'),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Last Name',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Skills (select multiple):'),
              // Search TextField
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search for skills...',
                ),
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 8),
              // Display checkboxes with filtered results based on search query
              Expanded(
                child: ListView(
                  children: skills.where((skill) {
                    return skill.toLowerCase().contains(_searchQuery.toLowerCase());
                  }).map((skill) {
                    return CheckboxListTile(
                      title: Text(skill),
                      value: _selectedSkills.contains(skill),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected != null) {
                            if (selected) {
                              _selectedSkills.add(skill);
                            } else {
                              _selectedSkills.remove(skill);
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: _saveSkills,
                child: const Text('Save and Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
