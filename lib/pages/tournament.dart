import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'admin.dart';

class tournament extends StatefulWidget {
  const tournament({Key? key}) : super(key: key);

  @override
  State<tournament> createState() => _tournamentState();
}

class _tournamentState extends State<tournament> {
  String tournament = "Choose One Tournament";
  CollectionReference championship =
      FirebaseFirestore.instance.collection('Tournament');
  final passcodeController = TextEditingController();
  final Stream<QuerySnapshot> dataStream =
      FirebaseFirestore.instance.collection("Tournament").snapshots();

  textChanged(String games) {
    setState(() {
      tournament = games;
    });
  }

  Widget buildGames() => StreamBuilder(
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
                                AssetImage('images/tennis (1).png'),
                          ),
                          title: Text(storedocs[i]['Name']),
                          subtitle:
                              Text('Sponsor by : ${storedocs[i]['Sponsor']} '),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            textChanged(storedocs[i]['Name']);
                            Navigator.of(context).pop(false);
                          })
                    ],
                  )),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_task),
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
                              "Type PassCode",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 40),
                            TextField(
                              decoration:
                                  InputDecoration(hintText: 'Pass Code'),
                              controller: passcodeController,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(250, 50),
                                  textStyle: TextStyle(fontSize: 16),
                                  primary: Colors.green),
                              onPressed: () {
                                if (int.parse(passcodeController.text.trim()) ==
                                    171899) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => admin()));
                                  passcodeController.text = "";
                                } else {
                                  passcodeController.text = "";
                                }
                              },
                              child: Text("Confirm"),
                            ),
                          ]),
                        ),
                      ),
                    ))));
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(80, 50),
                          textStyle: TextStyle(fontSize: 16),
                          primary: Color.fromRGBO(22, 160, 133, 10)),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => buildGames(),
                        );
                      },
                      child: Text("Choose"),
                    ),
                    SizedBox(width: 30),
                    Text(
                      tournament,
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: FaIcon(
                            FontAwesomeIcons.peopleGroup,
                            size: 40,
                            color: Color.fromRGBO(46, 134, 193, 10),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SecondScreen(value: tournament)));
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Teams')
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: FaIcon(
                            FontAwesomeIcons.award,
                            size: 40,
                            color: Color.fromRGBO(46, 134, 193, 10),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    MatchScreen(value: tournament)));
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Match')
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: FaIcon(
                            FontAwesomeIcons.medal,
                            size: 40,
                            color: Color.fromRGBO(46, 134, 193, 10),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ResultScreen(value: tournament)));
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Results')
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text('Congratulation to All',
                    style: TextStyle(fontSize: 20, color: Colors.green)),
                SizedBox(height: 30),
                SingleChildScrollView(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Champions")
                          .where("Name", isEqualTo: tournament)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('No Data');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                          tileColor: Colors.blue[100],
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                storedocs[i]['Image']),
                                          ),
                                          title: Text(storedocs[i]['Team']),
                                          subtitle:
                                              Text(' ${storedocs[i]['Name']}'),
                                          trailing: Text(
                                              ' ${storedocs[i]['Trophy']}'),
                                          onTap: () {})
                                    ],
                                  )),
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}

class SecondScreen extends StatelessWidget {
  final String value;

  const SecondScreen({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Teams"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Teams")
                        .where(
                          "Name",
                          isEqualTo: value,
                        )
                        .orderBy("Team")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("No Data"));
                      }

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

                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              storedocs.length,
                              (i) => Column(
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.all(5),
                                          width: double.infinity,
                                          height: 260,
                                          child: Card(
                                              color: Color.fromRGBO(
                                                  233, 247, 239, 10),
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        storedocs[i]["Team"],
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Divider(
                                                    height: 2,
                                                    thickness: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${storedocs[i]["Player1"]}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          "${storedocs[i]["Player4"]}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${storedocs[i]["Player2"]}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          "${storedocs[i]["Player5"]}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${storedocs[i]["Player3"]}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          "${storedocs[i]["Player6"]}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              )))
                                    ],
                                  )),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      );
}

class MatchScreen extends StatefulWidget {
  final String value;

  const MatchScreen({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  String dropdownValue = 'Choose';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Matches"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.value,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
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
                        'Choose',
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
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Games")
                        .where(
                          "Name",
                          isEqualTo: widget.value,
                        )
                        .where("Stage", isEqualTo: dropdownValue)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("No Data"));
                      }

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

                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              storedocs.length,
                              (i) => Column(
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.all(5),
                                          width: double.infinity,
                                          height: 200,
                                          child: Card(
                                              color: Color.fromRGBO(
                                                  214, 234, 248, 10),
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${storedocs[i]["Team1"]} Vs ${storedocs[i]["Team2"]}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        '${storedocs[i]["Game"]}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Divider(
                                                    height: 2,
                                                    thickness: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${storedocs[i]["Player1"]} + ${storedocs[i]["Player2"]} (${storedocs[i]["Team1"]})",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          storedocs[i]
                                                              ["Score1"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${storedocs[i]["Player3"]} + ${storedocs[i]["Player4"]} (${storedocs[i]["Team2"]})",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          storedocs[i]
                                                              ["Score2"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ]),
                                              )))
                                    ],
                                  )),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      );
}

class ResultScreen extends StatefulWidget {
  final String value;

  const ResultScreen({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String dropdownValue = 'Choose';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Results"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.value,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                        'Choose',
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
                SizedBox(height: 10),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Results")
                        .where(
                          "Name",
                          isEqualTo: widget.value,
                        )
                        .where("Stage", isEqualTo: dropdownValue)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("No Data"));
                      }

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

                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              storedocs.length,
                              (i) => Column(
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.all(5),
                                          width: double.infinity,
                                          height: 200,
                                          child: Card(
                                              color: Color.fromRGBO(
                                                  245, 203, 167, 10),
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${storedocs[i]["Team1"]} Vs ${storedocs[i]["Team2"]}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        '${storedocs[i]["Stage"]}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Divider(
                                                    height: 2,
                                                    thickness: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${storedocs[i]["Team1"]}",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          storedocs[i]
                                                              ["Score1"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          storedocs[i]
                                                              ["Score3"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          storedocs[i]
                                                              ["Score5"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          " ${storedocs[i]["Team2"]}",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          storedocs[i]
                                                              ["Score2"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          storedocs[i]
                                                              ["Score4"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          storedocs[i]
                                                              ["Score6"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ]),
                                              )))
                                    ],
                                  )),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      );
}
