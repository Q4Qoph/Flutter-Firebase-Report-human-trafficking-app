import 'package:flutter/material.dart';
import 'package:project_app1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project_app1/models/app_user.dart';

class AddUpdatePage extends StatefulWidget {
  @override
  _AddUpdatePageState createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _detail = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final DatabaseService _database = DatabaseService(uid: user?.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Updates',
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Detail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter detail';
                  }
                  return null;
                },
                onSaved: (value) {
                  _detail = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _database.submitUpdate(_title, _detail);
                    Navigator.pop(context); // Close the add update page
                  }
                },
                child: Text(
                  'Save Update',
                  style: TextStyle(color: Colors.lightGreen.shade900),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
