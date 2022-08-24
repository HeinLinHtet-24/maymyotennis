// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maymyo_tennis_club/models/auth.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class member extends StatefulWidget {
  const member({Key? key}) : super(key: key);

  @override
  State<member> createState() => _memberState();
}

class _memberState extends State<member> {
  final users = FirebaseAuth.instance.currentUser!;

  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passcodeController = TextEditingController();
  final pointsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

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
    final format = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: Text('Member'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Memeber Data',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.people), hintText: 'Member Name'),
                  controller: nameController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.supervisor_account),
                      hintText: 'Role'),
                  controller: roleController,
                ),
                SizedBox(height: 20),
                DateTimeField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      hintText: 'Date Of Birth'),
                  format: format,
                  onShowPicker: (context, currenValue) async {
                    final date = showDatePicker(
                        context: context,
                        initialDate: currenValue ?? DateTime.now(),
                        firstDate: DateTime(1930),
                        lastDate: DateTime(2100));
                    return date;
                  },
                  controller: dateController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email), hintText: 'Email'),
                  controller: emailController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password), hintText: 'Password'),
                  controller: passwordController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.star), hintText: 'Pass Code'),
                  controller: passcodeController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.point_of_sale),
                      hintText: 'Points'),
                  controller: pointsController,
                  keyboardType: TextInputType.number,
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
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50),
                          textStyle: TextStyle(fontSize: 16),
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
                      textStyle: TextStyle(fontSize: 16),
                      primary: Colors.green),
                  onPressed: () async {
                    final path = 'files/${pickedFile!.name}';
                    final file = File(pickedFile!.path!);

                    final ref = FirebaseStorage.instance.ref().child(path);
                    uploadTask = ref.putFile(file);

                    final snapshot = await uploadTask!.whenComplete(() {});

                    String url = await snapshot.ref.getDownloadURL();

                    final FirebaseAuth auth = FirebaseAuth.instance;

                    Future<User> getCurrentUser() async {
                      return await auth.currentUser!;
                    }

                    await Authent().createUserWithEmailAndPassword(
                        emailController.text,
                        auth.currentUser!.uid,
                        passwordController.text,
                        url,
                        nameController.text,
                        roleController.text,
                        int.parse(passcodeController.text),
                        DateTime.parse(dateController.text),
                        0,
                        int.parse(pointsController.text));

                    nameController.text = "";
                    roleController.text = "";
                    passwordController.text = "";
                    passcodeController.text = "";
                    emailController.text = "";
                    pointsController.text = "";
                    dateController.text = "";
                  },
                  child: Text('Save Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
