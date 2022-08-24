import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class expenses extends StatefulWidget {
  const expenses({Key? key}) : super(key: key);

  @override
  State<expenses> createState() => _expensesState();
}

class _expensesState extends State<expenses> {
  final format = DateFormat('yyyy-MM-dd');
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final expensesController = TextEditingController();
  final remarkController = TextEditingController();

  final Stream<QuerySnapshot> dataStream =
      FirebaseFirestore.instance.collection("Expenses").snapshots();

  Future expense(ExpensesData expenses) async {
    final expense = FirebaseFirestore.instance.collection("Expenses").doc();
    expenses.id = expense.id;

    final json = expenses.toJson();
    await expense.set(json);
  }

  Widget expenses() {
    return Column(children: <Widget>[
      Text(
        'Expenses',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
      ),
      SizedBox(height: 40),
      DateTimeField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_month), hintText: 'Pick a Date'),
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
            prefixIcon: Icon(Icons.description), hintText: 'Description'),
        controller: descriptionController,
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.money), hintText: 'Expenses'),
        controller: expensesController,
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 20),
      TextField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.star_outlined), hintText: 'Remark'),
        controller: remarkController,
      ),
      SizedBox(height: 20),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(100, 50),
            textStyle: TextStyle(fontSize: 16),
            primary: Colors.red),
        onPressed: () {
          final expenses = ExpensesData(
              date: DateTime.parse(dateController.text),
              description: descriptionController.text.trim(),
              remark: remarkController.text.trim(),
              expenses: int.parse(expensesController.text));
          expense(expenses);
        },
        child: Text('Submit'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => expenses(),
          );
        },
      ),
      appBar: AppBar(
        title: Text('Expenses'),
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
                                    AssetImage('images/expense.png'),
                              ),
                              title: Text(storedocs[i]['Description']),
                              subtitle: Text(
                                  '${DateFormat.yMMMd().format((storedocs[i]["Date"]).toDate())}'),
                              trailing: Text(
                                '${storedocs[i]['Expenses']} MMK',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: ((context) => Dialog(
                                            child: SingleChildScrollView(
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListView(
                                                  shrinkWrap: true,
                                                  children: <Widget>[
                                                    Text(
                                                      storedocs[i]
                                                          ['Description'],
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      DateFormat.yMMMd().format(
                                                          (storedocs[i]["Date"])
                                                              .toDate()),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Amount : ${storedocs[i]['Expenses']} MMK',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.red),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      storedocs[i]['Remark'],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              minimumSize:
                                                                  Size(250, 50),
                                                              textStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          16),
                                                              primary: Color
                                                                  .fromRGBO(
                                                                      236,
                                                                      112,
                                                                      99,
                                                                      10)),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text("Close"),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ))));
                              },
                            )
                          ],
                        )),
              ),
            );
          }),
    );
  }
}

class ExpensesData {
  String id;
  late final DateTime date;
  final String description;
  final String remark;
  final int expenses;

  ExpensesData({
    this.id = '',
    required this.date,
    required this.description,
    required this.remark,
    required this.expenses,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Date": date,
        "Description": description,
        "Expenses": expenses,
        "Remark": remark,
      };

  static ExpensesData fromJson(Map<String, dynamic> json) => ExpensesData(
      date: (json['Date'] as Timestamp).toDate(),
      description: json['Description'],
      remark: json['Remark'],
      expenses: json['Price']);
}
