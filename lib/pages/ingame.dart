import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../pages/scores.dart';

enum SingingCharacter { Single, Double }

class ingame extends StatefulWidget {
  const ingame({Key? key}) : super(key: key);

  @override
  State<ingame> createState() => _ingameState();
}

class _ingameState extends State<ingame> {
  final users = FirebaseAuth.instance.currentUser;

  CollectionReference member = FirebaseFirestore.instance.collection('Members');
  CollectionReference room =
      FirebaseFirestore.instance.collection('CreateRoom');
  CollectionReference matches =
      FirebaseFirestore.instance.collection('Matches');

  Widget inGame() {
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
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                width: double.infinity,
                height: 300,
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
                      Padding(padding: EdgeInsets.all(10)),
                      Text(
                        'COURT 1',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${data['Player1']} + ${data['Player2']}',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Vs',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${data['Player3']} + ${data['Player4']}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(250, 50),
                            textStyle: TextStyle(fontSize: 16),
                            primary: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => scores()),
                          );
                        },
                        child: Text('Finish Match'),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'Matches are now playing',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.redAccent,
                ),
              ),
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'In Game',
            style: TextStyle(
              fontFamily: 'Lato',
            ),
          ),
        ),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
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
                    inGame(),
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ));
  }
}
