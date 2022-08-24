import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class notification extends StatefulWidget {
  const notification({Key? key}) : super(key: key);

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  final Stream<QuerySnapshot> dataStream = FirebaseFirestore.instance
      .collection("Notification")
      .where("MemberID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
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

            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                    storedocs.length,
                    (i) => Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/ring-bell.png'),
                              ),
                              title: Text(storedocs[i]['Reason']),
                              subtitle: Text(
                                  '${DateFormat.yMMMd().format((storedocs[i]["Date"]).toDate())}'),
                              trailing: Text(
                                '${storedocs[i]['Amount']} MMK',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {},
                            )
                          ],
                        )),
              ),
            );
          }),
    );
  }
}
