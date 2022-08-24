import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maymyo_tennis_club/pages/profile.dart';
import 'package:maymyo_tennis_club/view/addtournament.dart';
import 'package:maymyo_tennis_club/view/coupons.dart';
import 'package:maymyo_tennis_club/view/expenses.dart';
import 'package:maymyo_tennis_club/view/feesview.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  int members = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      width: double.infinity,
                      height: 200,
                      child: Card(
                        color: Color.fromRGBO(250, 128, 114, 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.peopleGroup,
                              size: 60,
                              color: Colors.white,
                            ),
                            Text(
                              'Members',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                future: FirebaseFirestore.instance
                                    .collection('Members')
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 50.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: FaIcon(
                            FontAwesomeIcons.receipt,
                            size: 40,
                            color: Color.fromRGBO(52, 73, 94, 10),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => expenses()));
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Expenses')
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: FaIcon(
                            FontAwesomeIcons.trophy,
                            size: 40,
                            color: Color.fromRGBO(52, 73, 94, 10),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => addtournament()));
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Tournament')
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: FaIcon(
                            FontAwesomeIcons.moneyBill,
                            size: 40,
                            color: Color.fromRGBO(52, 73, 94, 10),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => coupons()));
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Coupons')
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: FaIcon(
                            FontAwesomeIcons.dollarSign,
                            size: 40,
                            color: Color.fromRGBO(52, 73, 94, 10),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => feeview()));
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Fees')
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      width: 180,
                      height: 230,
                      child: Card(
                        color: Color.fromRGBO(46, 204, 113, 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.baseball,
                              size: 60,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Court 1',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                future: FirebaseFirestore.instance
                                    .collection('Matches')
                                    .where('Court', isEqualTo: 'Court1')
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 50.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      width: 180,
                      height: 230,
                      child: Card(
                        color: Color.fromRGBO(235, 152, 78, 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.baseball,
                              size: 60,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Court 2',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                future: FirebaseFirestore.instance
                                    .collection('Matches')
                                    .where('Court', isEqualTo: 'Court2')
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 50.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Notification')
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> querySnapshot) {
                    int sumTotal = 0;
                    if (querySnapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (querySnapshot.connectionState == ConnectionState.done) {
                      querySnapshot.data!.docs.forEach((doc) {
                        int value = doc['Amount'];
                        sumTotal = value + sumTotal;
                      });
                      return Text(
                        "Total Income: ${sumTotal} MMK",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(52, 73, 94, 10)),
                      );
                    }

                    return Text("");
                  },
                ),
                SizedBox(height: 10),
                FutureBuilder(
                  future:
                      FirebaseFirestore.instance.collection('Expenses').get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> querySnapshot) {
                    int sumTotal = 0;
                    if (querySnapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (querySnapshot.connectionState == ConnectionState.done) {
                      querySnapshot.data!.docs.forEach((doc) {
                        int value = doc['Expenses'];
                        sumTotal = value + sumTotal;
                      });
                      return Text(
                        "Total Expenses: ${sumTotal} MMK",
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      );
                    }

                    return Text("");
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 50),
                      textStyle: TextStyle(fontSize: 16),
                      primary: Color.fromRGBO(46, 134, 193, 10)),
                  onPressed: () {},
                  child: Text('Analysis'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
