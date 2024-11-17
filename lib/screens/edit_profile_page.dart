import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  // Load user data
  Future<void> _loadCurrentData() async {
    try {
      User currentUser = FirebaseAuth.instance.currentUser!;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      final userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null) {
        setState(() {
          _firstNameController.text = userData['first_name'] ?? '';
          _lastNameController.text = userData['last_name'] ?? '';

          // Pre-select skills from Firestore
          List<dynamic> skillsFromFirestore = userData['skills'] ?? [];
          _selectedSkills.clear();
          _selectedSkills.addAll(
            skillsFromFirestore.map((skill) => skill.toString()).toList(),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data: $e')),
      );
    }
  }

  // Save profile data
  Future<void> _saveProfile() async {
    try {
      setState(() {
        _isSaving = true;
      });

      User currentUser = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('Users').doc(currentUser.uid).update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'skills': _selectedSkills, // Save the selected skills
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context); // Return to profile page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16),
            const Text('Skills (select multiple):'),
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
                        if (selected == true) {
                          if (!_selectedSkills.contains(skill)) {
                            _selectedSkills.add(skill);
                          }
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
