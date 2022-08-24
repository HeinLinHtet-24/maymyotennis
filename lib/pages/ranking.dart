import 'package:flutter/material.dart';

class ranking extends StatefulWidget {
  const ranking({Key? key}) : super(key: key);

  @override
  State<ranking> createState() => _rankingState();
}

class _rankingState extends State<ranking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ranking')),
      body: Center(
        child: Text(
          'Ranking Page',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
