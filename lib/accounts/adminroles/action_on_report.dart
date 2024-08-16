import 'package:flutter/material.dart';
import 'package:project_app1/incident_report/models/report_model.dart';
import 'package:project_app1/services/database.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ReportDetailScreen extends StatefulWidget {
  final IncidentReport report;

  const ReportDetailScreen({Key? key, required this.report}) : super(key: key);

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  late DatabaseService _database;
  String? _selectedBody;
  bool _isApproved = false;
  String? _emailAddress;

  @override
  void initState() {
    super.initState();
    _database = DatabaseService();
    _isApproved = widget.report.status == 'Approved';
  }

  final List<String> _bodies = [
    'Police Department',
    'Fire Department',
    'Emergency Medical Services',
    'Environmental Agency',
    'Public Works Department'
  ];

  void _approveReport() async {
    await _database.updateReportStatus(widget.report.id!, 'Approved');
    setState(() {
      _isApproved = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report approved successfully')),
    );
  }

  void _assignToBody() async {
    if (_selectedBody != null) {
      await _database.assignReportToBody(widget.report.id!, _selectedBody!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report assigned to $_selectedBody')),
      );
    }
  }

  void _sendEmail() async {
    if (_selectedBody == null ||
        _emailAddress == null ||
        _emailAddress!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please select a body and enter a valid email address')),
      );
      return;
    }

    final Email email = Email(
      body: '''
      Report Details:
      - Category: ${widget.report.category ?? 'N/A'}
      - Date: ${widget.report.date?.toString().split(' ')[0] ?? 'N/A'}
      - Time: ${widget.report.time ?? 'N/A'}
      - Location: ${widget.report.location ?? 'N/A'}
      - Reporter Type: ${widget.report.reporterType ?? 'N/A'}
      - Description: ${widget.report.description ?? 'No description provided'}
      ''',
      subject: 'Incident Report - ${widget.report.category ?? 'N/A'}',
      recipients: [_emailAddress!],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email sent to $_selectedBody')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: $error')),
      );
      print('Error: $error');
    }
  }

  void _showEmailInputModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Enter Email for $_selectedBody',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _emailAddress = value;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_emailAddress != null && _emailAddress!.isNotEmpty) {
                        Navigator.pop(context);
                        _sendEmail();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid email')),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details ',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${widget.report.category ?? 'N/A'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
                'Date: ${widget.report.date?.toString().split(' ')[0] ?? 'N/A'}'),
            Text('Time: ${widget.report.time ?? 'N/A'}'),
            Text('Location: ${widget.report.location ?? 'N/A'}'),
            Text('Reporter Type: ${widget.report.reporterType ?? 'N/A'}'),
            SizedBox(height: 16),
            Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.report.description ?? 'No description provided'),
            SizedBox(height: 24),
            Text('Status: ${widget.report.status ?? 'Pending'}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            widget.report.mediaFiles!.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.report.mediaFiles?.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      String fileUrl = widget.report.mediaFiles![index];
                      return Image.network(
                        fileUrl,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Text('No media files'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isApproved ? null : _approveReport,
              child: Text(_isApproved ? 'Approved' : 'Approve Report'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedBody,
              hint: Text('Assign to a body'),
              isExpanded: true,
              items: _bodies.map((String body) {
                return DropdownMenuItem<String>(
                  value: body,
                  child: Text(body),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBody = newValue;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedBody != null ? _assignToBody : null,
              child: Text('Assign to Selected Body'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedBody != null
                  ? () => _showEmailInputModal(context)
                  : null,
              child: Text('Submit and Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}
