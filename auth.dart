import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user; //firebase user
  Observable<Map<String, dynamic>> profile; //custom user data in Firestore
  PublishSubject loading = PublishSubject();

  //constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }
//  Widget _handleCurrentScreen(BuildContext context) {
//    return new StreamBuilder<FirebaseUser>(
//        stream: FirebaseAuth.instance.onAuthStateChanged,
//        builder: (BuildContext context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.waiting) {
//            return new SplashScreen();
//          } else {
//            if (snapshot.hasData) {
//              return new MainScreen(firestore: firestore,
//                  uuid: snapshot.data.uid);
//            }
//            return new LoginScreen();
//          }
//        }
//    );
//  }

  Future<FirebaseUser> googleSignIn() async {
    //When user login success, the return variable firebaseuser contains some user information, like displayName, photoUrl…
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user = await _auth.signInWithCredential(
        credential); //other one SignInWithGoogle was deprecated so using this instead, found on stackoverflow
    updateUserData(user);
    updateUserData1(user);
    loading.add(false);
    print("signed in " + user.uid);
    return user;
  }

  void updateUserData1(FirebaseUser user) async {
    // add collection(our TO-do list into our database.
    Firestore.instance.collection('users').document(user.uid).collection('planner').document("newplan")   //todo experimental way of how to use todo list
        .setData({'Name of Module': ' Give name of Module',
      'To-Do For Module' : "Add what you need to get done for that module"})
        .then((onValue)
    {
      print('Created it in sub collection');
    })
        .catchError((e) {
      print('The sub collection wasnt avvdded for this reason: ' + e);}
    );
  }

  void updateUserData(FirebaseUser user) async {
    // add collection(our TO-do list into our database.
    DocumentReference ref = _db.collection('users').document(user.uid);
    return ref.setData({
      'email': user.email,
    }, merge: true);
  }

  void signOut() {
    _auth.signOut();
  }
}

final AuthService authService = AuthService();