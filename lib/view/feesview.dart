import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class feeview extends StatefulWidget {
  const feeview({Key? key}) : super(key: key);

  @override
  State<feeview> createState() => _feeviewState();
}

class _feeviewState extends State<feeview> {
  final Stream<QuerySnapshot> dataStream =
      FirebaseFirestore.instance.collection("Payment").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tennis Fees'),
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
                                    AssetImage('images/dollar (1).png'),
                              ),
                              title: Text(storedocs[i]['MemberName']),
                              subtitle: Text(
                                  '${DateFormat.yMMMd().format((storedocs[i]["Date"]).toDate())}'),
                              trailing: Text(
                                '${storedocs[i]['Price']} MMK',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
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
