import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar(
      {super.key, required this.defaultSelectedIndex});

  final int defaultSelectedIndex;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> iconList = [];
  List<String> textList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    iconList = [
      Icons.home,
      Icons.report_problem_rounded,
      Icons.auto_stories,
      Icons.account_box_rounded
    ];
    textList = ['Home', 'Report', 'Learn', 'Profile'];
    _selectedIndex = widget.defaultSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(iconList[i], i, textList[i]));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: _navBarItemList,
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index, String label) {
    return GestureDetector(
      onTap: () {
        navigateBottom(index);
      },
      child: Container(
        padding: EdgeInsets.only(top: 10),
        height: 60,
        width: MediaQuery.of(context).size.width / iconList.length,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightGreen.shade50, Colors.lightGreen],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        foregroundDecoration: index == _selectedIndex
            ? BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 4, color: Colors.lightGreen.shade900)),
              )
            : const BoxDecoration(),
        child: Column(
          children: [
            Icon(
              icon,
              color: index == _selectedIndex
                  ? Colors.lightGreen.shade900
                  : Colors.lightGreen.shade700,
            ),
            Text(label,
                style: TextStyle(
                  fontWeight: index == _selectedIndex
                      ? FontWeight.w600
                      : FontWeight.normal,
                  fontSize: 12,
                  color: index == _selectedIndex
                      ? Colors.lightGreen.shade900
                      : Colors.lightGreen.shade700,
                ))
          ],
        ),
      ),
    );
  }

  void navigateBottom(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/home");
        break;
      case 1:
        Navigator.pushNamed(context, "/report");
        break;
      case 2:
        Navigator.pushNamed(context, "/learn");
        break;
      case 3:
        Navigator.pushNamed(context, "/join");
        break;
      case 4:
        break;
    }
  }
}
