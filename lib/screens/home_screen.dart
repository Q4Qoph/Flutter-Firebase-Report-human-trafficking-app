import 'package:flutter/material.dart';
import 'package:project_app1/accounts/user.dart';
import 'package:project_app1/incident_report/screens/incident_report_screen.dart';
import 'package:project_app1/widgets/bottomnav.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stop Trafficking',
          style: TextStyle(
            color: Colors.lightGreen.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Container(),
        ),
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
              Icons.more_vert_sharp,
              color: Colors.lightGreen.shade800,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                    ),
                    child: Icon(
                      Icons.face,
                      size: 128,
                      color: Colors.lightGreen.shade800,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home_filled),
                    title: Text('Home'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.report_problem),
                    title: Text('Report'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.auto_stories),
                    title: Text('Learn'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {},
                  ),
                  Divider(color: Colors.lightGreen),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Setting'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.volunteer_activism),
              title: Text('Donate'),
              onTap: () {
                _launchDonateURL();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: panicButton(
                      'Panic Button ',
                      'In danger right now? make a quick Report',
                      '',
                      Icons.report_problem_sharp,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Many find themselves in human trafficking even without knowing",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.lightGreen.shade900,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Even more are the cases that are not brought to the spotlight",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: homepageButton(
                    'Report',
                    'Report an incident as a victim, witness or anonymously',
                    '/report',
                    Icons.report_gmailerrorred_outlined,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: homepageButton(
                    'Learn ',
                    'Get to know how and how to avoid being a victim',
                    '/learn',
                    Icons.menu_book_rounded,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: homepageButton(
                    "Account",
                    'Create an account to be able to track progress on your report',
                    '/join',
                    Icons.person,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: homepageButton(
                    "Update",
                    'Get and share the latest info, missing reports, alerts and more',
                    '',
                    Icons.dynamic_feed,
                    tabIndex: 1, // Pass the tab index for "Updates"
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        defaultSelectedIndex: 0,
      ),
    );
  }

  Widget homepageButton(
      String text, String info, String routeName, IconData icon,
      {int? tabIndex}) {
    return GestureDetector(
      onTap: () async {
        if (routeName == '') {
          if (tabIndex != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserScreen(initialTabIndex: tabIndex),
              ),
            );
          }
        } else {
          Navigator.of(context).pushNamed(routeName);
        }
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade100,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: iconDesign(icon),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.lightGreen.shade900,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    info,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.lightGreen.shade900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconDesign(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Center(
        child: Icon(icon),
      ),
    );
  }

  void _showPanicDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Emergency Alert'),
          content: Text(
              'We have received your location. Would you like to proceed with an emergency hotline call?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _makeEmergencyCall();
              },
            ),
          ],
        );
      },
    );
  }

  void _makeEmergencyCall() async {
    const phoneNumber = 'tel: 0798361771'; // Replace with your emergency number
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to make the call')),
      );
    }
  }

  Widget panicButton(
      String text, String info, String routeName, IconData icon) {
    return GestureDetector(
      onTap: _showPanicDialog,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade100,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: panicIconDesign(icon),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    info,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent.shade100,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget panicIconDesign(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.red,
        ),
      ),
    );
  }

  void _launchDonateURL() async {
    const donateURL =
        'https://github.com/Q4Qoph'; // Replace with your donation link
    if (await canLaunch(donateURL)) {
      await launch(donateURL);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open the donation link')),
      );
    }
  }
}
