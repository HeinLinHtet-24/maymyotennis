import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:maymyo_tennis_club/pages/dashboard.dart';
import 'package:maymyo_tennis_club/pages/fees.dart';
import 'package:maymyo_tennis_club/pages/ranking.dart';
import 'package:maymyo_tennis_club/view/finalmatch.dart';
import 'package:maymyo_tennis_club/view/games.dart';
import 'package:maymyo_tennis_club/view/semi.dart';
import 'package:maymyo_tennis_club/view/team.dart';

class addtournament extends StatefulWidget {
  const addtournament({Key? key}) : super(key: key);

  @override
  State<addtournament> createState() => _addtournamentState();
}

class _addtournamentState extends State<addtournament> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    team(),
    games(),
    semi(),
    finalmatch(),
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
            icon: FaIcon(FontAwesomeIcons.peopleGroup),
            label: 'Team',
            backgroundColor: Color.fromRGBO(251, 252, 252, 10),
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.award),
              label: 'Matches',
              backgroundColor: Color.fromRGBO(251, 252, 252, 10)),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.trophy),
              label: 'Tournament',
              backgroundColor: Color.fromRGBO(251, 252, 252, 10)),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.rankingStar),
              label: 'Results',
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
