import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'study_page.dart';

class AdminSeatList extends StatefulWidget {
  @override
  _AdminSeatMapState createState() {
    return _AdminSeatMapState();
  }
}

class _AdminSeatMapState extends State<AdminSeatList>  {
  Firestore firestore = Firestore();
  final DocumentReference documentReference =
      Firestore.instance.document("baby");
//  int total;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: <Widget>[
        new ListTile(
          title: Text("Availablilty    Desk number", style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
//          leading: Text("Availablilty", style: TextStyle(fontSize: 13.0), ),
          trailing: Text("Status       ", style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
        ),
        new Expanded(
            child: _buildBody(context),
        )
      ],
    ),
  );
  }

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    await firestore.settings(timestampsInSnapshotsEnabled: true);
  }
  ////////////////////////////////////////////////////////////////////////////// functions to determine the colour of seat and whether seat should be removed or not
  Color boolToColorAdmin(bool param1, bool param2, bool param3){
    if (param1 == true){                                          //if seat is taken
      if (param2 == true){                                        //if seat is taken and absent is true
        if(param3 == true){                                       //seat, absent and overdue all true
          return Colors.red;                                      //return red which indicates remove student
        }
        else{
          return Colors.orange;                                   //seat is occupied, student is absent, but not yet overdue
        }
      }
      else{
        return Colors.blue;                                     //return blue if seat is taken
      }
    }
    else{
      return Colors.green;                                        //seat is not taken so return green
    }
  }

  String removeUser(bool param1, bool param2, bool param3){       //function returns whether user should be removed or not: taken, absent, overdue
    if (param1 == true){                                          //if seat is taken
      if (param2 == true){                                        //if seat is taken and absent is true
        if(param3 == true){                                       //seat, absent and overdue all true
          return "TAP TO REMOVE USER";                                      //return red which indicates remove student
        }
        else{
          return "STUDENT AWAY FROM SEAT";                                   //seat is occupied, student is absent, but not yet overdue
        }
      }
      else{
        return "STUDENT IN SEAT";                                     //return blue if seat is taken
      }
    }
    else{
      return "AVAILABLE";                                        //seat is not taken so return green
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  void clearTotal(){                            //to keep track of total occupancy, we need to decrement the count
    //////////////////////////////////////////////////// decrease total occupancy in library

    final DocumentReference totalRef= Firestore.instance.document('/library_capacity/capacity');    //total variable path
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(totalRef);
      if (postSnapshot.exists) {
        if(postSnapshot.data['c'] > 0){
          await tx.update(totalRef, <String, dynamic>{'c': postSnapshot.data['c'] - 1});      //increment count
        }
      }
    });
    ////////////////////////////////////////////////////
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
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

    final record = Record.fromSnapshot(data);
      return Padding(
        key: ValueKey(record.desk),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(record.desk),
            leading: Icon(
                Icons.event_seat, color: boolToColorAdmin(record.taken, record.absent, record.overdue,), size: 20.0),
//              trailing: Text("${record.taken.toString()}     ${record.absent.toString()}     ${record.overdue.toString()}"),
                trailing: Text("${removeUser(record.taken, record.absent, record.overdue)}"),
            onTap: () {
              record.reference.updateData(
                  {'taken': false,
                    'absent': false,
                    'overdue': false,
                  }
              );
              clearTotal();
            }
          ),
        ),
      );

  }
}

class Record {
  final String desk;
  final bool absent;
  final bool overdue;
  final bool taken;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['absent'] != null),
        assert(map['overdue'] != null),
        assert(map['absent'] != null),
        assert(map['taken'] != null),
        taken = map['taken'],
        absent = map['absent'],
        desk = map['desk'],
        overdue = map['overdue'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}
