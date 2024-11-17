
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _saveSkills() async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(widget.uid).update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'skills': _selectedSkills,
        'email': FirebaseAuth.instance.currentUser!.email,
        'phone': widget.phone,
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save skills: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Skills')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('First Name:'),
            TextField(controller: _firstNameController),
            const SizedBox(height: 16),
            const Text('Last Name:'),
            TextField(controller: _lastNameController),
            const SizedBox(height: 16),
            const Text('Skills (select multiple):'),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search for skills...',
              ),
              onChanged: _onSearchChanged,
            ),
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
    );
  }
}
