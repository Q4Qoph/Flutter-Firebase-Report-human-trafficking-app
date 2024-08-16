import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app1/accounts/adminroles/edit_update.dart.dart';
import 'package:project_app1/services/database.dart';

class AdminUpdatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DatabaseService _database = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Updates',
            style: TextStyle(
                color: Colors.lightGreen.shade900,
                fontWeight: FontWeight.w600)),
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(20), child: Container()),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
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
              return ListTile(
                title: Text(update['title']),
                subtitle: Text(update['detail']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to a page to edit the update
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUpdatePage(
                                update.id, update['title'], update['detail']),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await _database.deleteUpdate(update.id);
                      },
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
