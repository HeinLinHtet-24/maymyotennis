import 'dart:ui';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class matches extends StatefulWidget {
  const matches({Key? key}) : super(key: key);

  @override
  State<matches> createState() => _matchesState();
}

class _matchesState extends State<matches> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  DatePickerController _controller = DatePickerController();

  DateTime _selectedValue = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.lock_clock_outlined),
          onPressed: () {
            _controller.animateToDate(DateTime.now());
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DatePicker(
                      DateTime.utc(2022, 8, 8),
                      height: 90,
                      controller: _controller,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.blueAccent,
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        // New date selected
                        setState(() {
                          _selectedValue = date;
                        });
                      },
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Matches")
                      .where(
                        "Date",
                        isGreaterThanOrEqualTo: _selectedValue,
                      )
                      .orderBy("Date")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                            color: Colors.white,
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
                                                      storedocs[i]["Court"],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .add_jm()
                                                          .format((storedocs[i]
                                                                  ["Date"])
                                                              .toDate()),
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
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "${storedocs[i]["Player1"]} + ${storedocs[i]["Player2"]}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        storedocs[i]["Score1"],
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
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "${storedocs[i]["Player3"]} + ${storedocs[i]["Player4"]}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        storedocs[i]["Score2"],
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
        ));
  }
}
