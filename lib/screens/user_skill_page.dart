import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSkillsPage extends StatefulWidget {
  const UserSkillsPage({Key? key}) : super(key: key);

  @override
  State<UserSkillsPage> createState() => _UserSkillsPageState();
}

class _UserSkillsPageState extends State<UserSkillsPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final List<String> skills = [
  'HTML',
  'CSS',
  'Flutter',
  'Blockchain',
  'Machine Learning (ML)',
  'Android Development',
  'Java',
  'JavaScript',
  'Python',
  'C#',
  'Go',
  'Ruby',
  'Cloud Computing',
  'Docker',
  'Kubernetes',
  'DevOps',
  'AI/Deep Learning',
  'ReactJS',
  'NodeJS',
  'SQL/Database Management',
  'Cybersecurity',
  'Big Data',
  'Swift (iOS Development)',
  'TypeScript',
  'Firebase',
  '3D Modeling',
  '3D Designing',
  'Game Development (Unity/Unreal Engine)',
  'AR/VR Development',
  'UI/UX Design',
  'Data Science',
  'Robotics',
  'Embedded Systems',
  'Digital Marketing & SEO',
  'Computer Vision',
];

  final List<String> _selectedSkills = [];
  String _searchQuery = '';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _saveToFirestore() async {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || _selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('User_skill').add({
        'firstName': firstName,
        'lastName': lastName,
        'skills': _selectedSkills,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')));

      // Clear the form
      _firstNameController.clear();
      _lastNameController.clear();
      setState(() {
        _selectedSkills.clear();
        _searchQuery = '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSkills = skills
        .where((skill) => skill.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Skills'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Name Field
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Last Name Field
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Skills Section
            const Text(
              'Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Search Bar for Skills
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search Skills',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Skills List
            Expanded(
              child: ListView.builder(
                itemCount: filteredSkills.length,
                itemBuilder: (context, index) {
                  final skill = filteredSkills[index];
                  return CheckboxListTile(
                    title: Text(skill),
                    value: _selectedSkills.contains(skill),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                },
              ),
            ),

            // Save Button
            ElevatedButton(
              onPressed: _saveToFirestore,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
