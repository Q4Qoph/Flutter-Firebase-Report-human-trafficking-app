import 'package:flutter/material.dart';
import 'package:project_app1/incident_report/models/report_model.dart';
import 'package:project_app1/models/app_user.dart';
import 'package:project_app1/services/auth.dart';
import 'package:project_app1/services/database.dart';
import 'package:provider/provider.dart';

class MyReportTab extends StatelessWidget {
  const MyReportTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final AuthService _auth = AuthService();
    final DatabaseService _database = DatabaseService(uid: user?.uid);

    return StreamBuilder<List<IncidentReport>>(
      stream: _database.getUserIncidentReports(user?.uid ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No reports submitted yet');
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final report = snapshot.data![index];
            return Card(
              child: ListTile(
                title: Text(report.category ?? 'Uncategorized'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Date: ${report.date?.toString().split(' '[0] ?? 'N/A')}'),
                    Text('Status: ${report.status ?? 'Pending'}'),
                    if (report.assignedBody != null)
                      Text('Assigned to: ${report.assignedBody}'),
                  ],
                ),
                trailing: _getStatusIcon(report.status),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getStatusIcon(String? status) {
    switch (status) {
      case 'Approved':
        return Icon(Icons.check_circle, color: Colors.green);
      case 'Investigating':
        return Icon(Icons.search, color: Colors.blue);
      case 'Resolved':
        return Icon(Icons.task_alt, color: Colors.purple);
      default:
        return Icon(Icons.hourglass_empty, color: Colors.orange);
    }
  }
}
