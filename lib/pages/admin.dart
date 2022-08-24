import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:maymyo_tennis_club/pages/dashboard.dart';
import 'package:maymyo_tennis_club/pages/fees.dart';
import 'package:maymyo_tennis_club/pages/ranking.dart';
import 'memberlist.dart';
import 'members.dart';

class admin extends StatefulWidget {
  const admin({Key? key}) : super(key: key);

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    dashboard(),
    member(),
    memberlist(),
    fees(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget navi() {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.dashboard),
            label: 'Dashboard',
            backgroundColor: Color.fromRGBO(251, 252, 252, 10),
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              label: 'Member',
              backgroundColor: Color.fromRGBO(251, 252, 252, 10)),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.list),
              label: 'List',
              backgroundColor: Color.fromRGBO(251, 252, 252, 10)),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.coins),
              label: 'Fees',
              backgroundColor: Color.fromRGBO(251, 252, 252, 10)),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        unselectedItemColor: Color.fromRGBO(170, 183, 184, 10),
        selectedItemColor: Color.fromRGBO(34, 153, 84, 10),
        iconSize: 30,
        onTap: _onItemTapped,
        elevation: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(213, 219, 219, 10),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: navi(),
    );
  }
}
