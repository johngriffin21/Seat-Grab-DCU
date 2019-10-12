import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminMapp extends StatefulWidget {
  @override
  _SeatMapState createState() {
    return _SeatMapState();
  }
}

class _SeatMapState extends State<AdminMapp> {
  Widget _buildListBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('library_capacity').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final lrd = ListRecord.fromSnapshot(data);
    var lrdd = lrd.c;
    var percentage = (lrdd/9 * 100).toStringAsFixed(0);
    int calc = int.parse(percentage);
    int capacity = 100 - calc;
    return Padding(
        key: ValueKey(lrd.c),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 10.0, vertical: 40.0),
          padding: const EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(10.0),
            shape: BoxShape.rectangle,
            color: Colors.black.withOpacity(0.8),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                offset: new Offset(5.0, 5.0),
              ),
            ],
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end, //change
            children: <Widget>[
              new Text(
                "Amount of seats free = $capacity %",
                style: new TextStyle(
                  color: Colors.cyan,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        )
//        child: Container(
//          child: ListTile(
//            title: Text("Percentage of Seats Taken = $percentage %" , style: new TextStyle(color: Colors.cyan, fontSize: 30.0)),
//        ),
//      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          new Expanded(
            child: _buildListBody(context),
          ),
          new Expanded(
            child: _buildGridBody(context),
          )
        ],
      ),
    );
  }

  Color boolToColor(bool code) {
    if (code == true) {
      return Colors.red;
    }
    else{
      return Colors.green;
    }
  }

  Widget _buildGridBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildGrid(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildGrid(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      crossAxisSpacing: 100.0,
      mainAxisSpacing: 1.0,
      crossAxisCount: 3,
      children: snapshot.map((data) => _buildGridItem(context, data)).toList()  ,
    );


  }


  Widget _buildGridItem(BuildContext context, DocumentSnapshot data) {
    final record = GridRecord.fromSnapshot(data);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Container(
          child: Icon(Icons.event_seat, color: boolToColor(record.taken), size: 20.0),
        )
    );
  }
}

class GridRecord {
  final String desk;
  final bool taken;
  final DocumentReference reference;

  GridRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['desk'] != null),
        assert(map['taken'] != null),
        desk = map['desk'],
        taken = map['taken'];

  GridRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$desk:$taken>";
}

class ListRecord {
  final DocumentReference reference;
  final num c;

  ListRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['c'] != null),
        c = map['c'];

  ListRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}