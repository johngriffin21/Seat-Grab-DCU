import 'dart:async';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class plannerMedthods {


  Future<void> addData(carData) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    Firestore.instance.collection('users').document(uid)
        .collection('planner')
        .add(carData);
  }

  getData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('planner')
        .getDocuments();
  }
  void deleteData(DocumentSnapshot doc) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    await Firestore.instance.collection('users').document(uid).collection(
        'planner')
        .document(doc.documentID)
        .delete(); //here we call delete function on document ID we have already gotten.//this disables our read button
  }
}