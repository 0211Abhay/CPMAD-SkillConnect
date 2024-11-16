import 'package:flutter/material.dart';

class CollectionsViewer extends StatefulWidget {
  @override
  _CollectionsViewerState createState() => _CollectionsViewerState();
}

class _CollectionsViewerState extends State<CollectionsViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Collection Viewer'),
      ),
      body: Center(child: Text('Collections Viewer')),
    );
  }
}