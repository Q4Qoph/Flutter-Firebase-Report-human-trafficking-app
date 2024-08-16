import 'package:flutter/material.dart';
import 'package:project_app1/accounts/user_tabs/add_updates.dart';
import 'package:project_app1/accounts/user_tabs/reports_tab.dart';
import 'package:project_app1/accounts/user_tabs/updates_tab.dart';
import 'package:project_app1/models/profile.dart';
import 'package:project_app1/widgets/bottomnav.dart';
import 'package:provider/provider.dart';
import 'package:project_app1/services/auth.dart';
import 'package:project_app1/services/database.dart';
import 'package:project_app1/models/app_user.dart';

class UserScreen extends StatelessWidget {
  final int initialTabIndex;

  const UserScreen({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final AuthService _auth = AuthService();
    final DatabaseService _database = DatabaseService(uid: user?.uid);

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        initialIndex: initialTabIndex, // Set the initial tab index
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile',
                style: TextStyle(
                    color: Colors.lightGreen.shade900,
                    fontWeight: FontWeight.w600)),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48),
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
                  Icons.search,
                  color: Colors.lightGreen.shade900,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none),
                color: Colors.lightGreen.shade800,
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
                  PopupMenuItem<String>(
                    height: 25,
                    value: 'settings',
                    child: Text('Settings',
                        style: TextStyle(color: Colors.lightGreen.shade900)),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<Profile?>(
                  stream: _database.profile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasData) {
                      return Text('No profile data available');
                    }
                    final profile = snapshot.data!;
                    return Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 40,
                            child: Icon(
                              Icons.person_3,
                              size: 30,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${profile.firstName} ${profile.lastName}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Email: ${profile.email}'),
                            if (profile.photoUrl != null &&
                                profile.photoUrl!.isNotEmpty)
                              Image.network(profile.photoUrl!,
                                  height: 100, width: 100),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Divider(
                  color: Colors.lightGreen.shade100,
                ),
                TabBar(
                  tabs: [
                    Tab(text: "My Report"),
                    Tab(text: "Updates"),
                  ],
                  indicatorColor: Colors.lightGreen.shade900,
                  labelColor: Colors.lightGreen.shade900,
                  unselectedLabelColor: Colors.lightGreen.shade300,
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      MyReportTab(),
                      UpdatesTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUpdatePage()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.lightGreen.shade900,
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            defaultSelectedIndex: 3,
          ),
        ),
      ),
    );
  }
}
