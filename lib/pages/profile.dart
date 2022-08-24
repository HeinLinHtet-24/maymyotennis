import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maymyo_tennis_club/pages/members.dart';
import '../pages/memberlist.dart';

class profile extends StatefulWidget {
  const profile({
    Key? key,
  }) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final format = DateFormat('yyyy-MM-dd');

  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final priceController = TextEditingController();
  final emailController = TextEditingController();
  final passcodeController = TextEditingController();
  final passwordController = TextEditingController();
  final pointsController = TextEditingController();
  final updatepointsController = TextEditingController();
  final users = FirebaseAuth.instance.currentUser;

  CollectionReference member = FirebaseFirestore.instance.collection('Members');

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  } // select Photo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: Column(
                  children: <Widget>[
                    ClipOval(
                      child: Image.network(
                        data['Images'],
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      data['MemberName'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data['Email'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                data['Match'].toString(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Match Played',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(data['Points'].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(
                                'Current Points',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              FutureBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                  future: FirebaseFirestore.instance
                                      .collection('Members')
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold));
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      return Text("");
                                    }
                                  }),
                              SizedBox(height: 5),
                              Text(
                                'Total Players',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 50),
                            textStyle: TextStyle(fontSize: 16),
                            primary: Colors.redAccent),
                        onPressed: () {
                          nameController.text = data['MemberName'];
                          roleController.text = data['Role'];
                          emailController.text = data['Email'];
                          passcodeController.text = data['PassCode'].toString();

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
                                              'Edit Profile',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 40),
                                            TextField(
                                              decoration: InputDecoration(
                                                  prefixIcon:
                                                      Icon(Icons.people),
                                                  hintText: 'Member Name'),
                                              controller: nameController,
                                            ),
                                            SizedBox(height: 20),
                                            TextField(
                                              decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                      Icons.supervisor_account),
                                                  hintText: 'Role'),
                                              controller: roleController,
                                            ),
                                            SizedBox(height: 20),
                                            TextField(
                                              decoration: InputDecoration(
                                                  prefixIcon: Icon(Icons.email),
                                                  hintText: 'Email'),
                                              controller: emailController,
                                            ),
                                            SizedBox(height: 20),
                                            TextField(
                                              decoration: InputDecoration(
                                                  prefixIcon: Icon(Icons.star),
                                                  hintText: 'Pass Code'),
                                              controller: passcodeController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                if (pickedFile != null)
                                                  Expanded(
                                                    child: Container(
                                                      width: 300,
                                                      height: 200,
                                                      color: Colors.grey,
                                                      child: Image.file(
                                                        File(pickedFile!.path!),
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                Spacer(),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          minimumSize:
                                                              Size(100, 50),
                                                          textStyle: TextStyle(
                                                              fontSize: 16),
                                                          primary: Colors.blue),
                                                  onPressed: selectFile,
                                                  child: Text('Photo'),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(250, 50),
                                                  textStyle:
                                                      TextStyle(fontSize: 16),
                                                  primary: Colors.green),
                                              onPressed: () async {
                                                final path =
                                                    'files/${pickedFile!.name}';
                                                final file =
                                                    File(pickedFile!.path!);

                                                final ref = FirebaseStorage
                                                    .instance
                                                    .ref()
                                                    .child(path);
                                                uploadTask = ref.putFile(file);

                                                final snapshot =
                                                    await uploadTask!
                                                        .whenComplete(() {});

                                                String url = await snapshot.ref
                                                    .getDownloadURL();

                                                final docUser =
                                                    FirebaseFirestore.instance
                                                        .collection("Members")
                                                        .doc(users!.uid);

                                                docUser.update({
                                                  'MemberName':
                                                      nameController.text,
                                                  "Images": url,
                                                  "Role": roleController.text,
                                                  "Email": emailController.text,
                                                  "PassCode": int.parse(
                                                      passcodeController.text),
                                                });

                                                nameController.text = "";
                                                roleController.text = "";
                                                passcodeController.text = "";
                                                emailController.text = "";
                                              },
                                              child: Text('Update Profile'),
                                            ),
                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                        child: Text('Edit Profile'))
                  ],
                )),
              );
            }
            return Text('');
          }),
    );
  }
}
