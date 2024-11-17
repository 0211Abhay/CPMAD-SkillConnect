import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NetworkDetailPage extends StatefulWidget {
  final String networkId; // ID of the selected network
  final String networkName; // Name of the network

  NetworkDetailPage({required this.networkId, required this.networkName});

  @override
  _NetworkDetailPageState createState() => _NetworkDetailPageState();
}

class _NetworkDetailPageState extends State<NetworkDetailPage> {
  late List<String> members;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  // Fetch members of the selected network
  Future<void> _fetchMembers() async {
    DocumentSnapshot networkDoc = await FirebaseFirestore.instance
        .collection('networks')
        .doc(widget.networkId)
        .get();

    setState(() {
      members = List<String>.from(networkDoc['members']);
    });
  }

  // Remove a member from the network
  Future<void> _kickMember(String memberId) async {
    try {
      await FirebaseFirestore.instance.collection('networks').doc(widget.networkId).update({
        'members': FieldValue.arrayRemove([memberId]),
      });
      setState(() {
        members.remove(memberId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Member removed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove member: ${e.toString()}')),
      );
    }
  }

  // Generate an invite link for the network
  void _generateInviteLink() async {
    String inviteId = FirebaseFirestore.instance.collection('invitations').doc().id;
    await FirebaseFirestore.instance.collection('invitations').doc(inviteId).set({
      'invitationId': inviteId,
      'networkId': widget.networkId,
      'sender': FirebaseAuth.instance.currentUser!.uid,
      'used': false,
    });

    String inviteLink = 'https://yourapp.com/invite?inviteId=$inviteId';
    print('Invite Link: $inviteLink');
    // You can share the invite link via email, chat, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invite link generated: $inviteLink')),
    );
  }

  // Accept the invitation and join the network
  Future<void> _acceptInvite(String inviteId) async {
    DocumentSnapshot inviteDoc = await FirebaseFirestore.instance.collection('invitations').doc(inviteId).get();
    if (inviteDoc.exists && !(inviteDoc['used'] as bool)) {
      String networkId = inviteDoc['networkId'];
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Add user to the network
      await FirebaseFirestore.instance.collection('networks').doc(networkId).update({
        'members': FieldValue.arrayUnion([userId]),
      });

      // Mark invitation as used
      await FirebaseFirestore.instance.collection('invitations').doc(inviteId).update({'used': true});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully joined the network!')),
      );
    } else {
      print('Invalid or already used invitation');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid or expired invitation')),
      );
    }
  }

  // Add a new member to the network
  Future<void> _inviteMember() async {
    TextEditingController memberEmailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invite Member'),
          content: TextField(
            controller: memberEmailController,
            decoration: InputDecoration(hintText: 'Enter email/ID of the user'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newMemberId = memberEmailController.text.trim();
                if (newMemberId.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance.collection('networks').doc(widget.networkId).update({
                      'members': FieldValue.arrayUnion([newMemberId]),
                    });

                    setState(() {
                      members.add(newMemberId);
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Member invited successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to invite member: ${e.toString()}')),
                    );
                  }
                }
              },
              child: Text('Invite'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.networkName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                String member = members[index];
                return ListTile(
                  title: Text(member),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _kickMember(member),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _inviteMember,
              child: Text('Invite Member'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _generateInviteLink, // Button to generate invite link
              child: Text('Generate Invite Link'),
            ),
          ),
        ],
      ),
    );
  }
}
