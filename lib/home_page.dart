import 'package:flutter/material.dart';
import 'package:project_app1/incident_report/screens/incident_report_screen.dart';
import 'package:project_app1/screens/home_screen.dart';
import 'package:project_app1/screens/join_screen.dart';
import 'package:project_app1/screens/learn_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List _listPages = [];
  late Widget _currentPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listPages
      ..add(HomeScreen())
      ..add(IncidentReportScreen())
      ..add(LearnScreen())
      ..add(JoinScreen());
    _currentPage = HomePage();
  }

  void _changePage(int selectedIndex) {
    setState(() {
      _currentIndex = selectedIndex;
      _currentPage = _listPages[selectedIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: _currentPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (selectedIndex) => _changePage(selectedIndex),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem_outlined),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Join',
          ),
        ],
      ),
    );
  }
}
