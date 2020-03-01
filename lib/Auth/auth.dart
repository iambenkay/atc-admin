import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Status { Uninitialized, Unauthenticated, Authenticated, Authenticating }

class Auth with ChangeNotifier {
  Status status;
  FirebaseAuth _auth;
  FirebaseUser user;
  Firestore store;
  Auth() {
    status = Status.Uninitialized;
    _auth = FirebaseAuth.instance;
    store = Firestore.instance;

    _auth.onAuthStateChanged.listen(_authStateChanged);
  }
  Future<bool> signIn(String email, String password) async {
    try {
      status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (_) {
      status = Status.Unauthenticated;
      notifyListeners();
      throw _;
    }
  }

  Future<void> signOut() {
    _auth.signOut();
    status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _authStateChanged(FirebaseUser u) async {
    if (u == null)
      status = Status.Unauthenticated;
    else {
      user = u;
      status = Status.Authenticated;
    }
    notifyListeners();
  }
}

Auth firebase = Auth();

Widget withFirebase(Consumer<Auth> w) {
  return ChangeNotifierProvider.value(value: firebase, child: w);
}
