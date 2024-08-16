import 'package:flutter/material.dart';
import 'package:project_app1/accounts/adminroles/action_on_report.dart';
import 'package:project_app1/accounts/adminroles/action_on_updates.dart';
import 'package:project_app1/accounts/user_tabs/add_updates.dart';
// import 'package:project_app1/accounts/adminroles/reportdetails.dart';
import 'package:project_app1/services/auth.dart';
import 'package:project_app1/widgets/bottomnav.dart';
import 'package:project_app1/services/database.dart';
import 'package:project_app1/incident_report/models/report_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final AuthService _auth = AuthService();
  late final DatabaseService _database;
  String? selectedCategory;
  Map<String, bool> categoryHasUnread = {};

  final List<String> categories = [
    'Child Trafficking',
    'Sexual Exploitation',
    'Labour Exploitation',
    'Domestic Servitude',
    'Forced criminality',
    'Forced Marriage',
    'Other',
    'Unknown'
  ];
  final List<IconData> catIcons = [
    Icons.child_care_outlined,
    Icons.people_outline_rounded,
    Icons.work_outline_sharp,
    Icons.forest_rounded,
    Icons.policy_rounded,
    Icons.woman,
    Icons.arrow_outward_sharp,
    Icons.device_unknown,
  ];

  @override
  void initState() {
    super.initState();
    _database = DatabaseService();
    _checkForUnreadNotifications();
  }

  Future<void> _checkForUnreadNotifications() async {
    var reports = await _database.getIncidentReports().first;
    setState(() {
      for (var category in categories) {
        categoryHasUnread[category] = reports.any((report) =>
            report.category == category &&
            report.isRead == false &&
            report.status != 'approved' &&
            report.assignedBody == null);
      }
    });
  }

  void _markAsRead(IncidentReport report) {
    _database.updateReportStatus(report.id!, 'read');
    _checkForUnreadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin',
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.lightGreen.shade900,
              ),
            ),
            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none),
                  color: Colors.lightGreen.shade800,
                ),
                if (categoryHasUnread.values.any((hasUnread) => hasUnread))
                  Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  )
              ],
            ),
            PopupMenuButton<String>(
              color: Colors.lightGreen.shade200,
              icon: Icon(
                Icons.more_vert_sharp,
                color: Colors.lightGreen.shade800,
              ),
              onSelected: (String value) async {
                if (value == 'logout') {
                  await _auth.signOut();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  height: 25,
                  value: 'logout',
                  child: Text('Logout',
                      style: TextStyle(color: Colors.lightGreen.shade900)),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi, Admin',
                    style: TextStyle(
                        color: Colors.lightGreen.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminUpdatesPage()),
                        );
                      },
                      child: Text(
                        'more',
                        style: TextStyle(color: Colors.lightGreen.shade800),
                      )),
                ],
              ),
            ),
            Container(
              height: 120,
              color: Colors.lightGreen.shade50,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.4,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedCategory == categories[index]
                                    ? Colors.lightGreen.shade600
                                    : Colors.lightGreen.shade500,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(catIcons[index],
                                    color: Colors.lightGreen.shade50),
                              ),
                            ),
                            if (categoryHasUnread[categories[index]] == true)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          categories[index],
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.lightGreen.shade900,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<List<IncidentReport>>(
                stream: _database.getIncidentReports(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No incident reports available.'));
                  }

                  List<IncidentReport> filteredReports = selectedCategory !=
                          null
                      ? snapshot.data!
                          .where(
                              (report) => report.category == selectedCategory)
                          .toList()
                      : snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      bool showNotification = report.isRead == false &&
                          report.status != 'approved' &&
                          report.assignedBody == null;
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 3,
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${report.category ?? 'Uncategorized'} Incident',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightGreen.shade900),
                                ),
                              ),
                              if (showNotification)
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Date: ${report.date?.toString().split(' ')[0] ?? 'N/A'}'),
                              Text('Time: ${report.time ?? 'N/A'}'),
                              Text('Location: ${report.location ?? 'N/A'}'),
                              Text('Status: ${report.status ?? 'N/A'}'),
                              Text(
                                  'Assigned Body: ${report.assignedBody ?? 'Not assigned'}'),
                            ],
                          ),
                          onTap: () {
                            _markAsRead(report);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReportDetailScreen(report: report),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(defaultSelectedIndex: 3),
      ),
    );
  }
}
