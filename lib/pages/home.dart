import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maymyo_tennis_club/pages/enter_match.dart';
import 'package:maymyo_tennis_club/pages/notification.dart';
import 'package:maymyo_tennis_club/pages/profile.dart';
import 'package:maymyo_tennis_club/pages/ranking.dart';
import 'package:maymyo_tennis_club/pages/tournament.dart';
import 'matches.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    enterMatch(),
    matches(),
    tournament(),
    profile(),
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
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Home',
            backgroundColor: Color.fromRGBO(251, 252, 252, 10),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_tennis_outlined),
              label: 'Matches',
              backgroundColor: Color.fromRGBO(251, 252, 252, 10)),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.trophy),
              label: 'Touranment',
              backgroundColor: Color.fromRGBO(251, 252, 252, 10)),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              label: 'Profile',
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
      appBar: AppBar(
        title: Text(
          'May Myo Tennis',
          style: TextStyle(
            fontFamily: 'Lato',
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => notification()),
                );
              },
              icon: Icon(Icons.notifications)),
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: navi(),
    );
  }
}
