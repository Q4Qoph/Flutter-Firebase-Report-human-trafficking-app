import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app1/services/database.dart';

class UpdatesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DatabaseService _database =
        DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('updates').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var updates = snapshot.data!.docs;

          return ListView.builder(
            itemCount: updates.length,
            itemBuilder: (context, index) {
              var update = updates[index];
              var updateData = update.data() as Map<String, dynamic>;
              String name = updateData.containsKey('name')
                  ? updateData['name']
                  : 'Unknown';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text(name[0]),
                ),
                title: Text(updateData['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(updateData['detail']),
                    SizedBox(height: 4),
                    Text(
                      'Posted by: $name',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
