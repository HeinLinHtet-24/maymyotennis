import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:maymyo_tennis_club/pages/court2enter.dart';
import 'package:maymyo_tennis_club/pages/home.dart';
import '../models/matchdata.dart';
import 'package:maymyo_tennis_club/pages/admin.dart';
import 'package:maymyo_tennis_club/pages/ingame.dart';
import 'package:maymyo_tennis_club/pages/play_match.dart';

class enterMatch extends StatefulWidget {
  const enterMatch({Key? key}) : super(key: key);

  @override
  State<enterMatch> createState() => _enterMatchState();
}

class _enterMatchState extends State<enterMatch> {
  final users = FirebaseAuth.instance.currentUser;

  CollectionReference member = FirebaseFirestore.instance.collection('Members');
  CollectionReference room =
      FirebaseFirestore.instance.collection('CreateRoom');
  CollectionReference ball =
      FirebaseFirestore.instance.collection('TennisBall');

  DateTime now = DateTime.now();
  int ballCount = 0;

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await room.doc("Court1").get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkIfDocExists2(String docId) async {
    try {
      var doc = await room.doc("Court2").get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future CreateRoom(Match match) async {
    final creatematch =
        FirebaseFirestore.instance.collection("CreateRoom").doc("Court1");
    match.id = "Court1";

    final json = match.toJson();
    await creatematch.set(json);
  }

  Future CreateRoom2(Match match) async {
    final creatematch =
        FirebaseFirestore.instance.collection("CreateRoom").doc("Court2");
    match.id = "Court2";

    final json = match.toJson();
    await creatematch.set(json);
  }

  Future CreateMatch(MatchData matchdata) async {
    final matchplay = FirebaseFirestore.instance.collection("Matches").doc();
    matchdata.id = matchplay.id;

    final json = matchdata.toJson();
    await matchplay.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: member.doc(users!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          //Data is output to the user
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return SafeArea(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(data['Images']),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text('${data['MemberName']}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${data['Role']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      FaIcon(
                        FontAwesomeIcons.coins,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 10),
                      Text('${data['Points']} points'),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        width: double.infinity,
                        height: 200,
                        child: Card(
                          color: Colors.blueAccent,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'COURT 1',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(250, 60),
                                    textStyle: TextStyle(fontSize: 16),
                                    primary: Colors.green),
                                onPressed: () async {
                                  if (await checkIfDocExists('Court1') ==
                                      true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => playmatch()));
                                  } else {
                                    final matchplay = MatchData(
                                        date: DateTime.parse("${now}"),
                                        starttime: DateTime.parse("${now}"),
                                        endtime: DateTime.parse("${now}"),
                                        player1: '${data['MemberName']}',
                                        player2: '',
                                        player3: '',
                                        player4: '',
                                        id1: '${data['id']}',
                                        id2: '',
                                        id3: '',
                                        id4: '',
                                        score1: '',
                                        score2: '',
                                        court: 'Court1');
                                    CreateMatch(matchplay);
                                    String value = matchplay.id;

                                    final match = Match(
                                      game: "Game1",
                                      date: DateTime.parse("${now}"),
                                      time: DateTime.parse("${now}"),
                                      createuser: '${data['MemberName']}',
                                      player1: '${data['MemberName']}',
                                      player2: '',
                                      player3: '',
                                      player4: '',
                                      image: '${data['Images']}',
                                      image2: '',
                                      image3: '',
                                      image4: '',
                                      matchid: value,
                                    );
                                    CreateRoom(match);

                                    final point = FirebaseFirestore.instance
                                        .collection("Members")
                                        .doc(users!.uid);

                                    point.update({
                                      'Points': data['Points'] - 1,
                                      'Match': data['Match'] + 1
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => playmatch()),
                                    );
                                  }
                                },
                                child: Text("PLAY GAME"),
                              ),
                              SizedBox(height: 20),
                              FutureBuilder<DocumentSnapshot>(
                                  future: room.doc("Court1").get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Something went wrong");
                                    }
                                    if (snapshot.hasData &&
                                        !snapshot.data!.exists) {
                                      return Text("Match Available",
                                          style:
                                              TextStyle(color: Colors.white));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      Map<String, dynamic> data = snapshot.data!
                                          .data() as Map<String, dynamic>;
                                      String room =
                                          "${data["CreateUser"]} created room";
                                      return Text(
                                        checkIfDocExists('Court1') != true
                                            ? room
                                            : "Match Available",
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }
                                    return Text("");
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: FaIcon(
                                FontAwesomeIcons.baseball,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                            child: FutureBuilder<DocumentSnapshot>(
                                future: ball.doc('Court1').get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  }
                                  if (snapshot.hasData &&
                                      !snapshot.data!.exists) {
                                    return Text("Document does not exist");
                                  }
                                  //Data is output to the user
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> data = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    return Text(
                                      "${data['Count']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    );
                                  }
                                  return Text("");
                                }),
                          ),
                          Text('Tennis Ball Played in Court 1'),
                          Spacer(),
                          Text(
                            'Renew',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        width: double.infinity,
                        height: 200,
                        child: Card(
                          color: Colors.blueAccent,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'COURT 2',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(250, 60),
                                    textStyle: TextStyle(fontSize: 16),
                                    primary: Colors.orange),
                                onPressed: () async {
                                  if (await checkIfDocExists2('Court2') ==
                                      true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                court2enter()));
                                  } else {
                                    final matchplay = MatchData(
                                        date: DateTime.parse("${now}"),
                                        starttime: DateTime.parse("${now}"),
                                        endtime: DateTime.parse("${now}"),
                                        player1: '${data['MemberName']}',
                                        player2: '',
                                        player3: '',
                                        player4: '',
                                        id1: '${data['id']}',
                                        id2: '',
                                        id3: '',
                                        id4: '',
                                        score1: '',
                                        score2: '',
                                        court: 'Court2');
                                    CreateMatch(matchplay);
                                    String value = matchplay.id;

                                    final match = Match(
                                      game: "Game1",
                                      date: DateTime.parse("${now}"),
                                      time: DateTime.parse("${now}"),
                                      createuser: '${data['MemberName']}',
                                      player1: '${data['MemberName']}',
                                      player2: '',
                                      player3: '',
                                      player4: '',
                                      image: '${data['Images']}',
                                      image2: '',
                                      image3: '',
                                      image4: '',
                                      matchid: value,
                                    );
                                    CreateRoom2(match);

                                    final point = FirebaseFirestore.instance
                                        .collection("Members")
                                        .doc(users!.uid);

                                    point.update({
                                      'Points': data['Points'] - 1,
                                      'Match': data['Match'] + 1
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => court2enter()),
                                    );
                                  }
                                },
                                child: Text("PLAY GAME"),
                              ),
                              SizedBox(height: 20),
                              FutureBuilder<DocumentSnapshot>(
                                  future: room.doc("Court2").get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Something went wrong");
                                    }
                                    if (snapshot.hasData &&
                                        !snapshot.data!.exists) {
                                      return Text("Match Available",
                                          style:
                                              TextStyle(color: Colors.white));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      Map<String, dynamic> data = snapshot.data!
                                          .data() as Map<String, dynamic>;
                                      String room =
                                          "${data["CreateUser"]} created room";
                                      return Text(
                                        checkIfDocExists2('Court2') != true
                                            ? room
                                            : "Match Available",
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }
                                    return Text("");
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: FaIcon(
                                FontAwesomeIcons.baseball,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                            child: FutureBuilder<DocumentSnapshot>(
                                future: ball.doc('Court2').get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  }
                                  if (snapshot.hasData &&
                                      !snapshot.data!.exists) {
                                    return Text("Document does not exist");
                                  }
                                  //Data is output to the user
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> data = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    return Text(
                                      "${data['Count']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    );
                                  }
                                  return Text("");
                                }),
                          ),
                          Text('Tennis Ball Played in Court 2'),
                          Spacer(),
                          Text(
                            'Renew',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => home()));
          }),
    );
  }
}

class Match {
  String id;
  final String game;
  late final DateTime date;
  late final DateTime time;
  final String createuser;
  final String player1;
  final String player2;
  final String player3;
  final String player4;
  final String image;
  final String image2;
  final String image3;
  final String image4;
  final String matchid;

  Match({
    this.id = '',
    required this.game,
    required this.date,
    required this.time,
    required this.createuser,
    required this.player1,
    required this.player2,
    required this.player3,
    required this.player4,
    required this.image,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.matchid,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Game": game,
        "Date": date,
        "Time": time,
        "CreateUser": createuser,
        "Player1": player1,
        "Player2": player2,
        "Player3": player3,
        "Player4": player4,
        "Image": image,
        "Image2": image2,
        "Image3": image3,
        "Image4": image4,
        "Matchid": matchid,
      };

  static Match fromJson(Map<String, dynamic> json) => Match(
        id: json['id'],
        game: json['Game'],
        date: (json['Date'] as Timestamp).toDate(),
        time: (json['Time'] as Timestamp).toDate(),
        createuser: json['CreateUser'],
        player1: json['Player1'],
        player2: json['Player2'],
        player3: json['Player3'],
        player4: json['Player4'],
        image: json['Image'],
        image2: json['Image2'],
        image3: json['Image3'],
        image4: json['Image4'],
        matchid: json['Matchid'],
      );
}
