import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NetworkDetailPage extends StatefulWidget {
  final String networkId;
  final String networkName;

  NetworkDetailPage({required this.networkId, required this.networkName});

  @override
  _NetworkDetailPageState createState() => _NetworkDetailPageState();
}

class _NetworkDetailPageState extends State<NetworkDetailPage> {
  List<DocumentSnapshot> _users = []; // List of users from Firestore
  List<Map<String, dynamic>> _inviteRequests = []; // Store invite requests

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Load registered users from Firestore
    _loadInviteRequests(); // Load any pending invite requests
  }

  // Function to load users from Firestore
  Future<void> _loadUsers() async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await userCollection.get();

    setState(() {
      _users = querySnapshot.docs;
    });
  }

  // Function to load invite requests for the current network
  Future<void> _loadInviteRequests() async {
    final inviteRequestCollection = FirebaseFirestore.instance.collection('inviteRequests');
    final querySnapshot = await inviteRequestCollection
        .where('networkId', isEqualTo: widget.networkId)
        .get();

    setState(() {
      _inviteRequests = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // Function to send an invite to a user
  Future<void> _sendInvite(String userId) async {
    // Check if the user has already been invited or is already a member
    final inviteRequestCollection = FirebaseFirestore.instance.collection('inviteRequests');
    final existingInvite = await inviteRequestCollection
        .where('userId', isEqualTo: userId)
        .where('networkId', isEqualTo: widget.networkId)
        .get();

    if (existingInvite.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User is already invited or a member!')));
      return;
    }

    // Create the invite request document
    await inviteRequestCollection.add({
      'networkId': widget.networkId,
      'userId': userId,
      'status': 'pending', // The request is initially pending
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invite sent!')));
  }

  // Function to accept an invite
  Future<void> _acceptInvite(String userId) async {
    // Update the invite request status to 'accepted'
    final inviteRequestCollection = FirebaseFirestore.instance.collection('inviteRequests');
    final inviteQuery = await inviteRequestCollection
        .where('userId', isEqualTo: userId)
        .where('networkId', isEqualTo: widget.networkId)
        .get();

    if (inviteQuery.docs.isEmpty) return;

    // Get the invite document and update the status
    final inviteDoc = inviteQuery.docs.first;
    await inviteDoc.reference.update({'status': 'accepted'});

    // Add the user to the network
    final networkCollection = FirebaseFirestore.instance.collection('networks');
    await networkCollection.doc(widget.networkId).update({
      'members': FieldValue.arrayUnion([userId]),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have joined the network!')));
  }

  // Function to reject an invite
  Future<void> _rejectInvite(String userId) async {
    // Update the invite request status to 'rejected'
    final inviteRequestCollection = FirebaseFirestore.instance.collection('inviteRequests');
    final inviteQuery = await inviteRequestCollection
        .where('userId', isEqualTo: userId)
        .where('networkId', isEqualTo: widget.networkId)
        .get();

    if (inviteQuery.docs.isEmpty) return;

    final inviteDoc = inviteQuery.docs.first;
    await inviteDoc.reference.update({'status': 'rejected'});

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invite rejected')));
  }

  // Function to display user details
  Widget _buildUserList() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index].data() as Map<String, dynamic>;
        final userId = _users[index].id;

        // Check if the user is already in the network or has a pending invite
        final hasPendingInvite = _inviteRequests.any((request) =>
            request['userId'] == userId &&
            request['status'] == 'pending');

        final isMember = user['networks']?.contains(widget.networkId) ?? false;

        return ListTile(
          title: Text(user['name']),
          subtitle: Text(isMember ? 'Already a member' : hasPendingInvite ? 'Invite pending' : 'Invite to join'),
          trailing: isMember
              ? null
              : hasPendingInvite
                  ? null
                  : ElevatedButton(
                      onPressed: () => _sendInvite(userId),
                      child: Text('Invite'),
                    ),
        );
      },
    );
  }

  // Function to display pending invite requests
  Widget _buildInviteRequests() {
    return ListView.builder(
      itemCount: _inviteRequests.length,
      itemBuilder: (context, index) {
        final request = _inviteRequests[index];
        final userId = request['userId'];
        final status = request['status'];
        final userName = _users.firstWhere((user) => user.id == userId)['name'];

        return ListTile(
          title: Text(userName),
          subtitle: Text('Status: $status'),
          trailing: status == 'pending'
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () => _acceptInvite(userId),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => _rejectInvite(userId),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.networkName)),
      body: Column(
        children: [
          Expanded(
            child: _buildUserList(),
          ),
          Expanded(
            child: _buildInviteRequests(),
          ),
        ],
      ),
    );
  }
}
