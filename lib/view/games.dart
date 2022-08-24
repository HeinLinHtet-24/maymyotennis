import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class games extends StatefulWidget {
  const games({Key? key}) : super(key: key);

  @override
  State<games> createState() => _gamesState();
}

class _gamesState extends State<games> {
  String dropdownValue = 'Group';
  final team1Controller = TextEditingController();
  final team2Controller = TextEditingController();
  final nameController = TextEditingController();
  final gameController = TextEditingController();
  final player1Controller = TextEditingController();
  final player2Controller = TextEditingController();
  final player3Controller = TextEditingController();
  final player4Controller = TextEditingController();
  final score1Controller = TextEditingController();
  final score2Controller = TextEditingController();

  Future gameMatch(GameData games) async {
    final game = FirebaseFirestore.instance.collection("Games").doc();
    games.id = game.id;

    final json = games.toJson();
    await game.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Match Data',
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
                Row(
                  children: [
                    Text('Choose Stage'),
                    SizedBox(width: 30),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      iconSize: 30,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.blueAccent,
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'Group',
                        'Quarter-final',
                        'Semi-final',
                        'Final'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.data_object), hintText: 'Game'),
                  controller: gameController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group), hintText: 'Team'),
                  controller: team1Controller,
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
                      prefixIcon: Icon(Icons.flag), hintText: 'Score 1'),
                  controller: score1Controller,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group), hintText: 'Opponent Team'),
                  controller: team2Controller,
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
                      prefixIcon: Icon(Icons.flag), hintText: 'Score 2'),
                  controller: score2Controller,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 50),
                      textStyle: TextStyle(fontSize: 16),
                      primary: Colors.green),
                  onPressed: () {
                    final games = GameData(
                        name: nameController.text.trim(),
                        stage: dropdownValue,
                        game: 'Game ${gameController.text.trim()}',
                        team1: 'Team ${team1Controller.text.trim()}',
                        player1: player1Controller.text.trim(),
                        player2: player2Controller.text.trim(),
                        score1: score1Controller.text.trim(),
                        team2: 'Team ${team2Controller.text.trim()}',
                        player3: player3Controller.text.trim(),
                        player4: player4Controller.text.trim(),
                        score2: score2Controller.text.trim());
                    gameMatch(games);

                    team1Controller.text = "";
                    team2Controller.text = "";
                    gameController.text = "";
                    player1Controller.text = "";
                    player2Controller.text = "";
                    player3Controller.text = "";
                    player4Controller.text = "";
                    score1Controller.text = "";
                    score2Controller.text = "";
                  },
                  child: Text('Save Match Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameData {
  String id;
  final String name;
  final String stage;
  final String game;
  final String team1;
  final String player1;
  final String player2;
  final String score1;
  final String team2;
  final String player3;
  final String player4;
  final String score2;

  GameData({
    this.id = '',
    required this.name,
    required this.stage,
    required this.game,
    required this.team1,
    required this.player1,
    required this.player2,
    required this.score1,
    required this.team2,
    required this.player3,
    required this.player4,
    required this.score2,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "Stage": stage,
        "Game": game,
        "Team1": team1,
        "Player1": player1,
        "Player2": player2,
        "Score1": score1,
        "Team2": team2,
        "Player3": player3,
        "Player4": player4,
        "Score2": score2,
      };

  static GameData fromJson(Map<String, dynamic> json) => GameData(
        id: json['id'],
        name: json['Name'],
        stage: json['Stage'],
        game: json['Game'],
        team1: json['Team1'],
        player1: json['Player1'],
        player2: json['Player2'],
        score1: json['Score1'],
        team2: json['Team2'],
        player3: json['Player3'],
        player4: json['Player4'],
        score2: json['Score2'],
      );
}
