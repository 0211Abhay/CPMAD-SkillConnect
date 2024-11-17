import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import
import 'package:skillconnect_app/screens/login_page.dart';
import 'package:skillconnect_app/screens/network_detail_screen.dart';
import 'package:skillconnect_app/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentView = 'Chats'; // Possible values: 'Chats', 'Requests', 'Network'
  final List<String> _chats = ['Chat 1', 'Chat 2', 'Chat 3'];
  final List<String> _requests = ['Request 1', 'Request 2', 'Request 3', 'Request 4'];
  List<Map<String, dynamic>> _network = []; // List to store networks dynamically

  @override
  void initState() {
    super.initState();
    _loadNetworks(); // Load networks on initialization
  }

  // Function to fetch networks dynamically
  Future<void> _loadNetworks() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('networks')
        .where('members', arrayContains: currentUserId)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _network = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    });
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

  // Function to create a new network
  void _createNetwork() async {
    TextEditingController networkNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create a Network'),
          content: TextField(
            controller: networkNameController,
            decoration: InputDecoration(hintText: 'Enter Network Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String networkName = networkNameController.text.trim();
                if (networkName.isNotEmpty) {
                  // Add network to Firestore
                  String networkId = FirebaseFirestore.instance.collection('networks').doc().id;
                  await FirebaseFirestore.instance.collection('networks').doc(networkId).set({
                    'networkId': networkId,
                    'name': networkName,
                    'admin': FirebaseAuth.instance.currentUser!.uid,
                    'members': [FirebaseAuth.instance.currentUser!.uid],
                  });
                  Navigator.pop(context);

                  // Optional: Show confirmation to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Network "$networkName" created successfully!')),
                  );
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;

          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.blue[800]),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: const Text(
                        'Welcome!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Are you sure you want to log out?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              _logout();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Logout'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('View Profile'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: isWideScreen
                                ? MainAxisAlignment.spaceEvenly
                                : MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentView = 'Chats';
                                  });
                                },
                                child: const Text('Chats'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: _currentView == 'Chats' ? Colors.black : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: isWideScreen
                                      ? const Size(120, 48)
                                      : const Size(100, 40),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentView = 'Requests';
                                  });
                                },
                                child: const Text('Requests'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: _currentView == 'Requests' ? Colors.black : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: isWideScreen
                                      ? const Size(120, 48)
                                      : const Size(100, 40),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentView = 'Network';
                                  });
                                },
                                child: const Text('Network'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: _currentView == 'Network' ? Colors.black : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: isWideScreen
                                      ? const Size(120, 48)
                                      : const Size(100, 40),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _currentView == 'Chats'
                                  ? _chats.length
                                  : _currentView == 'Requests'
                                      ? _requests.length
                                      : _network.length,
                              itemBuilder: (context, index) {
                                String item = _currentView == 'Chats'
                                    ? _chats[index]
                                    : _currentView == 'Requests'
                                        ? _requests[index]
                                        : _network[index]['name']; // Display network name
                                return ListTile(
                                  title: Text(
                                    item,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NetworkDetailPage(
          networkId: _network[index]['networkId'],
          networkName: _network[index]['name'],
        ),
      ),
    );
  
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_currentView == 'Chats') {
                                  print('Starting a new chat');
                                } else if (_currentView == 'Requests') {
                                  print('Sending a new request');
                                } else if (_currentView == 'Network') {
                                  _createNetwork(); // Create a network
                                }
                              },
                              child: Text(
                                _currentView == 'Chats'
                                    ? 'Start New Chat'
                                    : _currentView == 'Requests'
                                        ? 'Send Request'
                                        : 'Create Network',
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
