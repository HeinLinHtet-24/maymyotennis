import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';
import '../models/matchdata.dart';

class memberlist extends StatefulWidget {
  const memberlist({Key? key}) : super(key: key);

  @override
  State<memberlist> createState() => _memberlistState();
}

class _memberlistState extends State<memberlist> {
  final users = FirebaseAuth.instance.currentUser!;
  final format = DateFormat('yyyy-MM-dd');
  DateTime now = DateTime.now();

  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final priceController = TextEditingController();
  final emailController = TextEditingController();
  final passcodeController = TextEditingController();
  final passwordController = TextEditingController();
  final pointsController = TextEditingController();
  final updatepointsController = TextEditingController();

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future sellPoints(PointsData points) async {
    final sellPoints = FirebaseFirestore.instance.collection("Points").doc();
    points.id = sellPoints.id;

    final json = points.toJson();
    await sellPoints.set(json);
  }

  Future noti(Notification notification) async {
    final notipayment =
        FirebaseFirestore.instance.collection("Notification").doc();
    notification.id = notipayment.id;

    final json = notification.toJson();
    await notipayment.set(json);
  }

  final Stream<QuerySnapshot> dataStream =
      FirebaseFirestore.instance.collection("Members").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member List'),
        actions: [Icon(Icons.search)],
      ),
      body: StreamBuilder(
          stream: dataStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            trailing: const Icon(Icons.point_of_sale),
                            onTap: () {
                              nameController.text = storedocs[i]['MemberName'];
                              roleController.text = storedocs[i]['Role'];
                              emailController.text = storedocs[i]['Email'];

                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: <Widget>[
                                                Text(
                                                  'Sell Points',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 40),
                                                TextField(
                                                  decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                          Icons.verified_user),
                                                      hintText: 'Member Name'),
                                                  controller: nameController,
                                                ),
                                                SizedBox(height: 20),
                                                TextField(
                                                  decoration: InputDecoration(
                                                      prefixIcon:
                                                          Icon(Icons.email),
                                                      hintText: 'Email'),
                                                  controller: emailController,
                                                ),
                                                SizedBox(height: 20),
                                                TextField(
                                                  decoration: InputDecoration(
                                                      prefixIcon:
                                                          Icon(Icons.money),
                                                      hintText: 'Price'),
                                                  controller: priceController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  "Current Points : ${storedocs[i]['Points']} points",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                                SizedBox(height: 20),
                                                TextField(
                                                  decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                          Icons.point_of_sale),
                                                      hintText:
                                                          'Update Points'),
                                                  controller:
                                                      updatepointsController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                SizedBox(
                                                  height: 20,
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
                                                  onPressed: () {
                                                    final sellpoints = PointsData(
                                                        date: DateTime.parse(
                                                            "${now}"),
                                                        membername:
                                                            '${storedocs[i]['MemberName']}',
                                                        memberid:
                                                            '${storedocs[i]['id']}',
                                                        price: int.parse(
                                                            priceController
                                                                .text),
                                                        points: int.parse(
                                                            updatepointsController
                                                                .text));
                                                    sellPoints(sellpoints);

                                                    final docUser =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "Members")
                                                            .doc(storedocs[i]
                                                                ['id']);

                                                    docUser.update({
                                                      'MemberName':
                                                          nameController.text,
                                                      "Role":
                                                          roleController.text,
                                                      "Email":
                                                          emailController.text,
                                                      "Points": storedocs[i]
                                                              ['Points'] +
                                                          int.parse(
                                                              updatepointsController
                                                                  .text)
                                                    });

                                                    final noticate = Notification(
                                                        date: DateTime.parse(
                                                            "${now}"),
                                                        memberid: storedocs[i]
                                                            ['id'],
                                                        membername: storedocs[i]
                                                            ['MemberName'],
                                                        amount: int.parse(
                                                            priceController
                                                                .text),
                                                        reason:
                                                            'Current points: ${storedocs[i]['Points']} points');
                                                    noti(noticate);

                                                    nameController.text = "";
                                                    roleController.text = "";
                                                    dateController.text = "";
                                                    priceController.text = "";
                                                    emailController.text = "";
                                                    pointsController.text = "";
                                                    updatepointsController
                                                        .text = "";
                                                  },
                                                  child: Text('Confirm'),
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                            },
                          )
                        ],
                      )),
            );
          }),
    );
  }
}

class Notification {
  String id;
  late final DateTime date;
  final String memberid;
  final String membername;
  final int amount;
  final String reason;

  Notification({
    this.id = '',
    required this.date,
    required this.memberid,
    required this.membername,
    required this.amount,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Date": date,
        "MemberID": memberid,
        "MemberName": membername,
        "Amount": amount,
        "Reason": reason,
      };

  static Notification fromJson(Map<String, dynamic> json) => Notification(
        id: json['id'],
        date: (json['Date'] as Timestamp).toDate(),
        memberid: json['MemberID'],
        membername: json['MemberName'],
        amount: json['Amount'],
        reason: json['Reason'],
      );
}
