import 'package:cloud_firestore/cloud_firestore.dart';

class MatchData {
  String id;
  late final DateTime date;
  late final DateTime starttime;
  late final DateTime endtime;
  final String id1;
  final String player1;
  final String id2;
  final String player2;
  final String score1;
  final String id3;
  final String player3;
  final String id4;
  final String player4;
  final String score2;
  final String court;

  MatchData(
      {this.id = '',
      required this.date,
      required this.starttime,
      required this.endtime,
      required this.player1,
      required this.player2,
      required this.player3,
      required this.player4,
      required this.id1,
      required this.id2,
      required this.id3,
      required this.id4,
      required this.score1,
      required this.score2,
      required this.court});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Date": date,
        "StartTime": starttime,
        "EndTime": endtime,
        "Player1": player1,
        "Player2": player2,
        "Player3": player3,
        "Player4": player4,
        "id1": id1,
        "id2": id2,
        "id3": id3,
        "id4": id4,
        "Score1": score1,
        "Score2": score2,
        "Court": court,
      };

  static MatchData fromJson(Map<String, dynamic> json) => MatchData(
        id: json['id'],
        date: (json['Date'] as Timestamp).toDate(),
        starttime: (json['StartTime'] as Timestamp).toDate(),
        endtime: (json['EndTime'] as Timestamp).toDate(),
        player1: json['Player1'],
        player2: json['Player2'],
        player3: json['Player3'],
        player4: json['Player4'],
        id1: json['id1'],
        id2: json['id2'],
        id3: json['id3'],
        id4: json['id4'],
        score1: json['Score1'],
        score2: json['Score2'],
        court: json['Court'],
      );
}

class BallData {
  String id;
  late final DateTime opendate;
  final String court;
  final int count;

  BallData({
    this.id = '',
    required this.opendate,
    required this.court,
    required this.count,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "OpenDate": opendate,
        "Court": court,
        "Count": count,
      };

  static BallData fromJson(Map<String, dynamic> json) => BallData(
        id: json['id'],
        opendate: (json['OpenDate'] as Timestamp).toDate(),
        court: json['Court'],
        count: json['Count'],
      );
}

class PointsData {
  String id;
  late final DateTime date;
  final String membername;
  final String memberid;
  final int price;
  final int points;

  PointsData({
    this.id = '',
    required this.date,
    required this.membername,
    required this.memberid,
    required this.price,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Date": date,
        "MemberID": memberid,
        "MemberName": membername,
        "Price": price,
        "Points": points,
      };

  static PointsData fromJson(Map<String, dynamic> json) => PointsData(
        id: json['id'],
        date: (json['Date'] as Timestamp).toDate(),
        memberid: json['MemberID'],
        membername: json['MemberName'],
        price: json['Price'],
        points: json['Points'],
      );
}
