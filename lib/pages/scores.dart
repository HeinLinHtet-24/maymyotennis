import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maymyo_tennis_club/main.dart';
import '../pages/home.dart';
import '../models/matchdata.dart';

class scores extends StatefulWidget {
  const scores({Key? key}) : super(key: key);

  @override
  State<scores> createState() => _scoresState();
}

class _scoresState extends State<scores> {
  final score1Controller = TextEditingController();
  final score2Controller = TextEditingController();

  CollectionReference room =
      FirebaseFirestore.instance.collection('CreateRoom');
  CollectionReference matches =
      FirebaseFirestore.instance.collection('Matches');

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scores'),
        ),
        body: FutureBuilder<DocumentSnapshot>(
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
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Match Result of Court 1',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Date: 2-8-2022'),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Start Time: 4:00 pm"),
                              Text(
                                  "End Time: ${now.hour.toString() + ":" + now.minute.toString() + " pm"}"),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${data['Player1']} + ${data['Player2']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: score1Controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: 'Score 1'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${data['Player3']} + ${data['Player4']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: score2Controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: 'Score 2'),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(250, 50),
                              textStyle: TextStyle(fontSize: 16),
                              primary: Colors.green),
                          onPressed: () async {
                            final matches = FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(data['Matchid']);

                            matches.update({
                              'EndTime': DateTime.parse("${now}"),
                              'Score1': score1Controller.text.trim(),
                              'Score2': score2Controller.text.trim(),
                            });

                            var collection = FirebaseFirestore.instance
                                .collection('TennisBall');
                            var docSnapshot =
                                await collection.doc('Court1').get();
                            if (docSnapshot.exists) {
                              Map<String, dynamic>? data = docSnapshot.data();
                              var value = data?['Count'];

                              final ball = FirebaseFirestore.instance
                                  .collection("TennisBall")
                                  .doc('Court1');

                              ball.update({
                                'Count': value + 1,
                              });
                            }

                            final deleteroom = FirebaseFirestore.instance
                                .collection("CreateRoom")
                                .doc('Court1');

                            deleteroom.delete();
                            // matches data inserted
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => home()),
                            );
                          },
                          child: Text('Save Scores'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ));
  }
}
