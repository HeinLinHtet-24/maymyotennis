import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class finalmatch extends StatefulWidget {
  const finalmatch({Key? key}) : super(key: key);

  @override
  State<finalmatch> createState() => _finalmatchState();
}

class _finalmatchState extends State<finalmatch> {
  final team1Controller = TextEditingController();
  final teamController = TextEditingController();
  final tournamentController = TextEditingController();
  final numberController = TextEditingController();
  final trophyController = TextEditingController();
  final numController = TextEditingController();
  final stageController = TextEditingController();
  final team2Controller = TextEditingController();
  String Game1 = "Game 1";
  String Game2 = "Game 2";
  String Game3 = "Game 3";
  final score1Controller = TextEditingController();
  final score2Controller = TextEditingController();
  final score3Controller = TextEditingController();
  final score4Controller = TextEditingController();
  final score5Controller = TextEditingController();
  final score6Controller = TextEditingController();

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  } // select Photo

  Future matchResult(ResultData results) async {
    final result = FirebaseFirestore.instance.collection("Results").doc();
    results.id = result.id;

    final json = results.toJson();
    await result.set(json);
  }

  Future championResult(ChampionData champions) async {
    final champion = FirebaseFirestore.instance.collection("Champions").doc();
    champions.id = champion.id;

    final json = champions.toJson();
    await champion.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.star),
        backgroundColor: Colors.orange,
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) => Dialog(
                      child: SingleChildScrollView(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          Text(
                            "Winners",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 40),
                          TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.group),
                                hintText: 'Team'),
                            controller: teamController,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.star_rate),
                                hintText: 'Trophy'),
                            controller: trophyController,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.flag_sharp),
                                hintText: 'Tournament Name'),
                            controller: numController,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.star_rate),
                                hintText: 'Number'),
                            controller: numberController,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              if (pickedFile != null)
                                Expanded(
                                  child: Container(
                                    width: 300,
                                    height: 200,
                                    color: Colors.grey,
                                    child: Image.file(
                                      File(pickedFile!.path!),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(100, 50),
                                    textStyle: TextStyle(fontSize: 16),
                                    primary: Colors.blue),
                                onPressed: selectFile,
                                child: Text('Photo'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(250, 50),
                                textStyle: TextStyle(fontSize: 16),
                                primary: Colors.green),
                            onPressed: () async {
                              final path = 'files/${pickedFile!.name}';
                              final file = File(pickedFile!.path!);

                              final ref =
                                  FirebaseStorage.instance.ref().child(path);
                              uploadTask = ref.putFile(file);

                              final snapshot =
                                  await uploadTask!.whenComplete(() {});

                              String url = await snapshot.ref.getDownloadURL();

                              final champion = ChampionData(
                                  team: 'Team ${teamController.text.trim()}',
                                  trophy: trophyController.text.trim(),
                                  name: numController.text.trim(),
                                  url: url,
                                  number:
                                      int.parse(numberController.text.trim()));
                              championResult(champion);

                              teamController.text = "";
                              trophyController.text = "";
                              numController.text = "";
                              numberController.text = "";
                            },
                            child: Text("Congratulation"),
                          ),
                        ]),
                      ),
                    ),
                  ))));
        },
      ),
      appBar: AppBar(
        title: Text('Championship'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Championship Results',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.flag_sharp),
                      hintText: 'Tournament Name'),
                  controller: tournamentController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.tour), hintText: 'Stage'),
                  controller: stageController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group), hintText: 'Team1'),
                  controller: team1Controller,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group), hintText: 'Team2'),
                  controller: team2Controller,
                ),
                SizedBox(height: 20),
                Text(
                  Game1,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.flag), hintText: 'Team1 Points'),
                  controller: score1Controller,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.flag), hintText: 'Team2 Points'),
                  controller: score2Controller,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Text(
                  Game2,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.flag), hintText: 'Team1 Points'),
                  controller: score3Controller,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.flag), hintText: 'Team2 Points'),
                  controller: score4Controller,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Text(
                  Game3,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.flag), hintText: 'Team1 Points'),
                  controller: score5Controller,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.flag), hintText: 'Team2 Points'),
                  controller: score6Controller,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 50),
                      textStyle: TextStyle(fontSize: 16),
                      primary: Colors.green),
                  onPressed: () {
                    final result = ResultData(
                        name: tournamentController.text.trim(),
                        stage: stageController.text.trim(),
                        team1: 'Team ${team1Controller.text.trim()}',
                        team2: 'Team ${team2Controller.text.trim()}',
                        game1: Game1,
                        game2: Game2,
                        game3: Game3,
                        score1: score1Controller.text.trim(),
                        score2: score2Controller.text.trim(),
                        score3: score3Controller.text.trim(),
                        score4: score4Controller.text.trim(),
                        score5: score5Controller.text.trim(),
                        score6: score6Controller.text.trim());
                    matchResult(result);

                    stageController.text = "";
                    team1Controller.text = "";
                    team2Controller.text = "";
                    score1Controller.text = "";
                    score2Controller.text = "";
                    score3Controller.text = "";
                    score4Controller.text = "";
                    score5Controller.text = "";
                    score6Controller.text = "";
                  },
                  child: Text('Save Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultData {
  String id;
  final String name;
  final String stage;
  final String team1;
  final String team2;
  final String game1;
  final String game2;
  final String game3;
  final String score1;
  final String score2;
  final String score3;
  final String score4;
  final String score5;
  final String score6;

  ResultData({
    this.id = '',
    required this.name,
    required this.stage,
    required this.team1,
    required this.team2,
    required this.game1,
    required this.game2,
    required this.game3,
    required this.score1,
    required this.score2,
    required this.score3,
    required this.score4,
    required this.score5,
    required this.score6,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "Stage": stage,
        "Team1": team1,
        "Team2": team2,
        "Game1": game1,
        "Game2": game2,
        "Game3": game3,
        "Score1": score1,
        "Score2": score2,
        "Score3": score3,
        "Score4": score4,
        "Score5": score5,
        "Score6": score6,
      };

  static ResultData fromJson(Map<String, dynamic> json) => ResultData(
        id: json['id'],
        name: json['Name'],
        stage: json['Stage'],
        team1: json['Team1'],
        team2: json['Team2'],
        game1: json['Game1'],
        game2: json['Game2'],
        game3: json['Game3'],
        score1: json['Score1'],
        score2: json['Score2'],
        score3: json['Score3'],
        score4: json['Score4'],
        score5: json['Score5'],
        score6: json['Score6'],
      );
}

class ChampionData {
  String id;
  final String team;
  final String trophy;
  final String name;
  final String url;
  final int number;

  ChampionData({
    this.id = '',
    required this.team,
    required this.trophy,
    required this.name,
    required this.url,
    required this.number,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Team": team,
        "Trophy": trophy,
        "Name": name,
        "Image": url,
        "Number": number,
      };

  static ChampionData fromJson(Map<String, dynamic> json) => ChampionData(
      id: json['id'],
      team: json['Team'],
      trophy: json['Trouphy'],
      name: json['Name'],
      url: json['Image'],
      number: json['Number']);
}
