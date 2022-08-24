import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../pages/ingame.dart';
import '../models/matchdata.dart';
import 'dart:async';

class playmatch extends StatefulWidget {
  const playmatch({Key? key}) : super(key: key);

  @override
  State<playmatch> createState() => _playmatchState();
}

class _playmatchState extends State<playmatch> {
  final passcodeController = TextEditingController();
  final users = FirebaseAuth.instance.currentUser;
  CollectionReference member = FirebaseFirestore.instance.collection('Members');
  CollectionReference room =
      FirebaseFirestore.instance.collection('CreateRoom');
  String datetime = DateFormat.yMMMd().format(DateTime.now());
  String time = "";
  String image2 =
      'https://firebasestorage.googleapis.com/v0/b/maymyo-tennis-30a6c.appspot.com/o/files%2Fadd.png?alt=media&token=45ed05c3-a1fd-487b-9ec4-d0283d04dfa6';
  String image3 =
      'https://firebasestorage.googleapis.com/v0/b/maymyo-tennis-30a6c.appspot.com/o/files%2Fadd.png?alt=media&token=45ed05c3-a1fd-487b-9ec4-d0283d04dfa6';
  String image4 =
      'https://firebasestorage.googleapis.com/v0/b/maymyo-tennis-30a6c.appspot.com/o/files%2Fadd.png?alt=media&token=45ed05c3-a1fd-487b-9ec4-d0283d04dfa6';
  String chooseplayer2 = "Player2";
  String chooseplayer3 = "Player3";
  String chooseplayer4 = "Player4";
  DateTime now = DateTime.now();

  textChanged2(String player2) {
    setState(() {
      chooseplayer2 = player2;
    });
  }

  textChanged3(String player3) {
    setState(() {
      chooseplayer3 = player3;
    });
  }

  textChanged4(String player4) {
    setState(() {
      chooseplayer4 = player4;
    });
  }

  onButtonPressed2(String value2) {
    setState(() {
      image2 = value2;
    });
  }

  onButtonPressed3(String value3) {
    setState(() {
      image3 = value3;
    });
  }

  onButtonPressed4(String value4) {
    setState(() {
      image4 = value4;
    });
  }

  final Stream<QuerySnapshot> dataStream =
      FirebaseFirestore.instance.collection("Members").snapshots();

  Widget buildSheet2() => StreamBuilder(
      stream: dataStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {}

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a['id'] = document.id;
        }).toList();

        return Column(
          children: List.generate(
              storedocs.length,
              (i) => Column(
                    children: <Widget>[
                      ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(storedocs[i]['Images']),
                          ),
                          title: Text(storedocs[i]['MemberName']),
                          subtitle: Text('${storedocs[i]['Points']} points'),
                          trailing: const Icon(Icons.sports_tennis_sharp),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: ((context) => Dialog(
                                        child: SingleChildScrollView(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView(
                                              shrinkWrap: true,
                                              children: <Widget>[
                                                Text(
                                                  "Type PassCode",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 40),
                                                TextField(
                                                  decoration: InputDecoration(
                                                      hintText: 'Pass Code'),
                                                  controller:
                                                      passcodeController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                SizedBox(height: 20),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          minimumSize:
                                                              Size(250, 50),
                                                          textStyle: TextStyle(
                                                              fontSize: 16),
                                                          primary:
                                                              Colors.green),
                                                  onPressed: () async {
                                                    if (storedocs[i]
                                                            ['PassCode'] ==
                                                        int.parse(
                                                            passcodeController
                                                                .text
                                                                .trim())) {
                                                      onButtonPressed2(
                                                          storedocs[i]
                                                              ['Images']);
                                                      textChanged2(storedocs[i]
                                                          ['MemberName']);

                                                      final docUser =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "CreateRoom")
                                                              .doc('Court1');

                                                      docUser.update({
                                                        'Player2': storedocs[i]
                                                            ['MemberName'],
                                                        "Image2": storedocs[i]
                                                            ['Images'],
                                                      });

                                                      final point =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Members")
                                                              .doc(storedocs[i]
                                                                  ['id']);

                                                      point.update({
                                                        'Points': storedocs[i]
                                                                ['Points'] -
                                                            1,
                                                        'Match': storedocs[i]
                                                                ['Match'] +
                                                            1,
                                                      });

                                                      var collection =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'CreateRoom');
                                                      var docSnapshot =
                                                          await collection
                                                              .doc('Court1')
                                                              .get();
                                                      if (docSnapshot.exists) {
                                                        Map<String, dynamic>?
                                                            data =
                                                            docSnapshot.data();
                                                        var value =
                                                            data?['Matchid'];

                                                        final matches =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Matches")
                                                                .doc(value);

                                                        matches.update({
                                                          'Player2': storedocs[
                                                              i]['MemberName'],
                                                          "id2": storedocs[i]
                                                              ['id'],
                                                        });
                                                      } // matches data inserted

                                                      Navigator.of(context)
                                                          .pop(false);
                                                    } else {}
                                                  },
                                                  child: Text("Confirm"),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ))));
                          })
                    ],
                  )),
        );
      });

  Widget buildSheet3() => StreamBuilder(
      stream: dataStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {}

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a['id'] = document.id;
        }).toList();

        return Column(
          children: List.generate(
              storedocs.length,
              (i) => Column(
                    children: <Widget>[
                      ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(storedocs[i]['Images']),
                          ),
                          title: Text(storedocs[i]['MemberName']),
                          subtitle: Text('${storedocs[i]['Points']} points'),
                          trailing: const Icon(Icons.sports_tennis_sharp),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: ((context) => Dialog(
                                        child: SingleChildScrollView(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView(
                                              shrinkWrap: true,
                                              children: <Widget>[
                                                Text(
                                                  "Type PassCode",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 40),
                                                TextField(
                                                  decoration: InputDecoration(
                                                      hintText: 'Pass Code'),
                                                  controller:
                                                      passcodeController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                SizedBox(height: 20),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          minimumSize:
                                                              Size(250, 50),
                                                          textStyle: TextStyle(
                                                              fontSize: 16),
                                                          primary:
                                                              Colors.green),
                                                  onPressed: () async {
                                                    if (storedocs[i]
                                                            ['PassCode'] ==
                                                        int.parse(
                                                            passcodeController
                                                                .text
                                                                .trim())) {
                                                      onButtonPressed3(
                                                          storedocs[i]
                                                              ['Images']);
                                                      textChanged3(storedocs[i]
                                                          ['MemberName']);

                                                      final docUser =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "CreateRoom")
                                                              .doc('Court1');

                                                      docUser.update({
                                                        'Player3': storedocs[i]
                                                            ['MemberName'],
                                                        "Image3": storedocs[i]
                                                            ['Images'],
                                                      });

                                                      final point =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Members")
                                                              .doc(storedocs[i]
                                                                  ['id']);

                                                      point.update({
                                                        'Points': storedocs[i]
                                                                ['Points'] -
                                                            1,
                                                        'Match': storedocs[i]
                                                                ['Match'] +
                                                            1
                                                      });

                                                      var collection =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'CreateRoom');
                                                      var docSnapshot =
                                                          await collection
                                                              .doc('Court1')
                                                              .get();
                                                      if (docSnapshot.exists) {
                                                        Map<String, dynamic>?
                                                            data =
                                                            docSnapshot.data();
                                                        var value =
                                                            data?['Matchid'];

                                                        final matches =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Matches")
                                                                .doc(value);

                                                        matches.update({
                                                          'Player3': storedocs[
                                                              i]['MemberName'],
                                                          "id3": storedocs[i]
                                                              ['id'],
                                                        });
                                                      } // matches data inserted

                                                      Navigator.of(context)
                                                          .pop(false);
                                                    } else {}
                                                  },
                                                  child: Text("Confirm"),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ))));
                          })
                    ],
                  )),
        );
      });

  Widget buildSheet4() => StreamBuilder(
      stream: dataStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {}

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a['id'] = document.id;
        }).toList();

        return Column(
          children: List.generate(
              storedocs.length,
              (i) => Column(
                    children: <Widget>[
                      ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(storedocs[i]['Images']),
                          ),
                          title: Text(storedocs[i]['MemberName']),
                          subtitle: Text('${storedocs[i]['Points']} points'),
                          trailing: const Icon(Icons.sports_tennis_sharp),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: ((context) => Dialog(
                                        child: SingleChildScrollView(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView(
                                              shrinkWrap: true,
                                              children: <Widget>[
                                                Text(
                                                  "Type PassCode",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 40),
                                                TextField(
                                                  decoration: InputDecoration(
                                                      hintText: 'Pass Code'),
                                                  controller:
                                                      passcodeController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                SizedBox(height: 20),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          minimumSize:
                                                              Size(250, 50),
                                                          textStyle: TextStyle(
                                                              fontSize: 16),
                                                          primary:
                                                              Colors.green),
                                                  onPressed: () async {
                                                    if (storedocs[i]
                                                            ['PassCode'] ==
                                                        int.parse(
                                                            passcodeController
                                                                .text
                                                                .trim())) {
                                                      onButtonPressed4(
                                                          storedocs[i]
                                                              ['Images']);
                                                      textChanged4(storedocs[i]
                                                          ['MemberName']);

                                                      final docUser =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "CreateRoom")
                                                              .doc('Court1');

                                                      docUser.update({
                                                        'Player4': storedocs[i]
                                                            ['MemberName'],
                                                        "Image4": storedocs[i]
                                                            ['Images'],
                                                      });

                                                      final point =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Members")
                                                              .doc(storedocs[i]
                                                                  ['id']);

                                                      point.update({
                                                        'Points': storedocs[i]
                                                                ['Points'] -
                                                            1,
                                                        'Match': storedocs[i]
                                                                ['Match'] +
                                                            1,
                                                      });

                                                      var collection =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'CreateRoom');
                                                      var docSnapshot =
                                                          await collection
                                                              .doc('Court1')
                                                              .get();
                                                      if (docSnapshot.exists) {
                                                        Map<String, dynamic>?
                                                            data =
                                                            docSnapshot.data();
                                                        var value =
                                                            data?['Matchid'];

                                                        final matches =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Matches")
                                                                .doc(value);

                                                        matches.update({
                                                          'Player4': storedocs[
                                                              i]['MemberName'],
                                                          "id4": storedocs[i]
                                                              ['id'],
                                                        });
                                                      } // matches data inserted
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    } else {}
                                                  },
                                                  child: Text("Confirm"),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ))));
                          })
                    ],
                  )),
        );
      });

  Widget buildbody() {
    return FutureBuilder<DocumentSnapshot>(
      future: room.doc('Court1').get(),
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
          return Stack(children: <Widget>[
            Image(
              image: new AssetImage('images/tennis Court.jpg'),
            ),
            Positioned(
              top: 20,
              left: 140,
              child: Column(
                children: [
                  Text(
                    'Date : ${now.day.toString() + "-" + now.month.toString() + "-" + now.year.toString()}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                      'Time : ${now.hour.toString() + ":" + now.minute.toString()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white))
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: 140,
              child: Text(
                time,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Positioned(
              top: 100,
              left: 70,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(data['Image']),
                ),
              ),
            ),
            Positioned(
                top: 180,
                left: 70,
                child: Text(
                  '${data['Player1']}',
                  style: TextStyle(color: Colors.white),
                )),
            Positioned(
              top: 100,
              left: 230,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        data['Image2'] != '' ? data['Image2'] : image2),
                  ),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => buildSheet2(),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 180,
                left: 230,
                child: Text(
                    data['Player2'] != '' ? data['Player2'] : chooseplayer2,
                    style: TextStyle(color: Colors.white))),
            Positioned(
              top: 400,
              left: 70,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        data['Image3'] != '' ? data['Image3'] : image3),
                  ),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => buildSheet3(),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 370,
                left: 80,
                child: Text(
                    data['Player3'] != '' ? data['Player3'] : chooseplayer3,
                    style: TextStyle(color: Colors.white))),
            Positioned(
              top: 400,
              left: 230,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        data['Image4'] != '' ? data['Image4'] : image4),
                  ),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => buildSheet4(),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 370,
                left: 230,
                child: Text(
                    data['Player4'] != '' ? data['Player4'] : chooseplayer4,
                    style: TextStyle(color: Colors.white))),
            Positioned(
                top: 480,
                left: 90,
                child: Text('သေချာမှကစားပွဲသို့ ဝင်ပေးပါရန်။',
                    style: TextStyle(color: Colors.redAccent))),
            Positioned(
              top: 520,
              left: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 50),
                    textStyle: TextStyle(fontSize: 16),
                    primary: Colors.orange),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ingame()),
                  );
                },
                child: Text('START'),
              ),
            ),
          ]);
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play Match')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Court 1',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 30),
              Row(
                children: [
                  Text('Match Type : Double'),
                  Spacer(),
                  Text('Number of Player : 4'),
                ],
              ),
              buildbody(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
          }),
    );
  }
}
