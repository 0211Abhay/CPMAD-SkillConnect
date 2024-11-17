import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillconnect_app/screens/login_page.dart';
import 'package:skillconnect_app/screens/profile_page.dart'; // Import the profile page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentView = 'Chats'; // Possible values: 'Chats', 'Requests', 'Network'
  final List<String> _chats = ['Chat 1', 'Chat 2', 'Chat 3'];
  final List<String> _requests = ['Request 1', 'Request 2', 'Request 3', 'Request 4'];
  final List<String> _network = ['Network 1', 'Network 2', 'Network 3'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.blue[800],
        ),
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
                        // Navigate to the ProfilePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()), // Add ProfilePage here
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Chats Button
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
                              minimumSize: const Size(120, 48),
                            ),
                          ),
                          // Requests Button
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
                              minimumSize: const Size(120, 48),
                            ),
                          ),
                          // Network Button
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
                              minimumSize: const Size(120, 48),
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
                                    : _network[index];
                            return ListTile(
                              title: Text(
                                item,
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                // Add specific action for each item if needed
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Action Button with similar styling
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
                              print('Connecting to a new user');
                            }
                          },
                          child: Text(
                            _currentView == 'Chats'
                                ? 'Start New Chat'
                                : _currentView == 'Requests'
                                    ? 'Send Request'
                                    : 'Connect User',
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
      ),
    );
  }
}
