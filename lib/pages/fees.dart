import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class fees extends StatefulWidget {
  const fees({Key? key}) : super(key: key);

  @override
  State<fees> createState() => _feesState();
}

class _feesState extends State<fees> {
  final users = FirebaseAuth.instance.currentUser!;
  final format = DateFormat('yyyy-MM-dd');
  DateTime now = DateTime.now();

  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final enddateController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  Future feePayment(Payment payment) async {
    final feepayment = FirebaseFirestore.instance.collection("Payment").doc();
    payment.id = feepayment.id;

    final json = payment.toJson();
    await feepayment.set(json);
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
        title: Text('Tennis Fees'),
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
                            trailing: const Icon(Icons.payment),
                            onTap: () {
                              nameController.text = storedocs[i]['MemberName'];

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
                                                  'Monthly Payment',
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
                                                DateTimeField(
                                                  decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                          Icons.calendar_month),
                                                      hintText: 'Payment Date'),
                                                  format: format,
                                                  onShowPicker: (context,
                                                      currenValue) async {
                                                    final date = showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            currenValue ??
                                                                DateTime.now(),
                                                        firstDate:
                                                            DateTime(1990),
                                                        lastDate:
                                                            DateTime(2100));
                                                    return date;
                                                  },
                                                  controller: dateController,
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
                                                DateTimeField(
                                                  decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                          Icons.calendar_month),
                                                      hintText: 'End Date'),
                                                  format: format,
                                                  onShowPicker: (context,
                                                      currenValue) async {
                                                    final date = showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            currenValue ??
                                                                DateTime.now(),
                                                        firstDate:
                                                            DateTime(1990),
                                                        lastDate:
                                                            DateTime(2100));
                                                    return date;
                                                  },
                                                  controller: enddateController,
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
                                                    final payment = Payment(
                                                        date: DateTime.parse(
                                                            dateController
                                                                .text),
                                                        enddate: DateTime.parse(
                                                            enddateController
                                                                .text),
                                                        price: int.parse(
                                                            priceController
                                                                .text),
                                                        memberid: storedocs[i]
                                                            ['id'],
                                                        membername:
                                                            nameController
                                                                .text);
                                                    feePayment(payment);

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
                                                            'Monthly Payment for ${now.month}');
                                                    noti(noticate);

                                                    nameController.text = "";
                                                    dateController.text = "";
                                                    enddateController.text = "";
                                                    priceController.text = "";
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

class Payment {
  String id;
  late final DateTime date;
  late final DateTime enddate;
  final String memberid;
  final String membername;
  final int price;

  Payment({
    this.id = '',
    required this.date,
    required this.enddate,
    required this.price,
    required this.memberid,
    required this.membername,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Date": date,
        "EndDate": enddate,
        "MemberID": memberid,
        "MemberName": membername,
        "Price": price,
      };

  static Payment fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        date: (json['Date'] as Timestamp).toDate(),
        enddate: (json['Date'] as Timestamp).toDate(),
        memberid: json['MemberID'],
        membername: json['MemberName'],
        price: json['Price'],
      );
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
