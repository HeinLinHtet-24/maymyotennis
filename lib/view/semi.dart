import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maymyo_tennis_club/pages/tournament.dart';

class semi extends StatefulWidget {
  const semi({Key? key}) : super(key: key);

  @override
  State<semi> createState() => _semiState();
}

class _semiState extends State<semi> {
  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final sponsorController = TextEditingController();

  Future tournamentMatch(TournamentData tournaments) async {
    final tournamentdata =
        FirebaseFirestore.instance.collection("Tournament").doc();
    tournaments.id = tournamentdata.id;

    final json = tournaments.toJson();
    await tournamentdata.set(json);
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: Text('Tournament'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Tournament Data',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                DateTimeField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      hintText: 'Tournament Date'),
                  format: format,
                  onShowPicker: (context, currenValue) async {
                    final date = showDatePicker(
                        context: context,
                        initialDate: currenValue ?? DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2100));
                    return date;
                  },
                  controller: dateController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.tour),
                      hintText: 'Tournament Name'),
                  controller: nameController,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.recent_actors),
                      hintText: 'Sponsor'),
                  controller: sponsorController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 50),
                      textStyle: TextStyle(fontSize: 16),
                      primary: Colors.green),
                  onPressed: () {
                    final tournamentdata = TournamentData(
                        name: nameController.text.trim(),
                        sponsor: sponsorController.text.trim(),
                        date: DateTime.parse(dateController.text));
                    tournamentMatch(tournamentdata);

                    nameController.text = "";
                    dateController.text = "";
                    sponsorController.text = "";
                  },
                  child: Text('Save Tournament Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TournamentData {
  String id;
  late final DateTime date;
  final String name;
  final String sponsor;

  TournamentData({
    this.id = '',
    required this.name,
    required this.sponsor,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "Date": date,
        "Sponsor": sponsor,
      };

  static TournamentData fromJson(Map<String, dynamic> json) => TournamentData(
        id: json['id'],
        name: json['Name'],
        date: (json['Date'] as Timestamp).toDate(),
        sponsor: json['Sponsor'],
      );
}
