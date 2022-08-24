import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class team extends StatefulWidget {
  const team({Key? key}) : super(key: key);

  @override
  State<team> createState() => _teamState();
}

class _teamState extends State<team> {
  final teamController = TextEditingController();
  final nameController = TextEditingController();
  final player1Controller = TextEditingController();
  final player2Controller = TextEditingController();
  final player3Controller = TextEditingController();
  final player4Controller = TextEditingController();
  final player5Controller = TextEditingController();
  final player6Controller = TextEditingController();

  Future teamGroup(TeamData teams) async {
    final team = FirebaseFirestore.instance.collection("Teams").doc();
    teams.id = team.id;

    final json = teams.toJson();
    await team.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Team Data',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.games),
                      hintText: 'Tournament Name'),
                  controller: nameController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group), hintText: 'Team'),
                  controller: teamController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.supervised_user_circle),
                      hintText: 'Player 1'),
                  controller: player1Controller,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.supervised_user_circle),
                      hintText: 'Player 2'),
                  controller: player2Controller,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.supervised_user_circle),
                      hintText: 'Player 3'),
                  controller: player3Controller,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.supervised_user_circle),
                      hintText: 'Player 4'),
                  controller: player4Controller,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.supervised_user_circle),
                      hintText: 'Player 5'),
                  controller: player5Controller,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.supervised_user_circle),
                      hintText: 'Player 6'),
                  controller: player6Controller,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 50),
                      textStyle: TextStyle(fontSize: 16),
                      primary: Colors.green),
                  onPressed: () {
                    final teams = TeamData(
                        name: nameController.text.trim(),
                        team: 'Team ${teamController.text.trim()}',
                        player1: player1Controller.text.trim(),
                        player2: player2Controller.text.trim(),
                        player3: player3Controller.text.trim(),
                        player4: player4Controller.text.trim(),
                        player5: player5Controller.text.trim(),
                        player6: player6Controller.text.trim());
                    teamGroup(teams);

                    teamController.text = "";
                    player1Controller.text = "";
                    player2Controller.text = "";
                    player3Controller.text = "";
                    player4Controller.text = "";
                    player5Controller.text = "";
                    player6Controller.text = "";
                  },
                  child: Text('Save Team Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeamData {
  String id;
  final String name;
  final String team;
  final String player1;
  final String player2;
  final String player3;
  final String player4;
  final String player5;
  final String player6;

  TeamData({
    this.id = '',
    required this.name,
    required this.team,
    required this.player1,
    required this.player2,
    required this.player3,
    required this.player4,
    required this.player5,
    required this.player6,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "Team": team,
        "Player1": player1,
        "Player2": player2,
        "Player3": player3,
        "Player4": player4,
        "Player5": player5,
        "Player6": player6,
      };

  static TeamData fromJson(Map<String, dynamic> json) => TeamData(
        id: json['id'],
        name: json['Name'],
        team: json['Team'],
        player1: json['Player1'],
        player2: json['Player2'],
        player3: json['Player3'],
        player4: json['Player4'],
        player5: json['Player5'],
        player6: json['Player6'],
      );
}
