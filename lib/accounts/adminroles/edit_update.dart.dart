import 'package:flutter/material.dart';
import 'package:project_app1/services/database.dart';

class EditUpdatePage extends StatefulWidget {
  final String updateId;
  final String initialTitle;
  final String initialDetail;

  EditUpdatePage(this.updateId, this.initialTitle, this.initialDetail);

  @override
  _EditUpdatePageState createState() => _EditUpdatePageState();
}

class _EditUpdatePageState extends State<EditUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _detail;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle;
    _detail = widget.initialDetail;
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService _database = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Updates ',
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
                initialValue: _title,
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
                initialValue: _detail,
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
                    await _database.updateUpdate(
                        widget.updateId, _title, _detail);
                    Navigator.pop(context); // Close the edit update page
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
