import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_todo/src/models/UserModel.dart';

enum AuthLoading {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering
}

class Auth extends ChangeNotifier {
  FirebaseAuth _auth;

  AuthLoading _authLoading = AuthLoading.Uninitialized;

  AuthLoading get authStatus => _authLoading;

  Stream<UserModel> get user =>
      _auth.authStateChanges().map<UserModel>(_fireaseUserMap);

  Auth() {
    _auth = FirebaseAuth.instance;

    _auth.authStateChanges().listen(authStateChanged);
  }

  Future<void> authStateChanged(User user) async {
    if (user == null) {
      _authLoading = AuthLoading.Unauthenticated;
    } else {
      _fireaseUserMap(user);
      _authLoading = AuthLoading.Authenticated;
    }

    notifyListeners();
  }

  UserModel _fireaseUserMap(User user) {
    if (user == null) return null;

    return UserModel(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL);
  }

  Future<bool> registerWithEmailandPassword(
      String email, String password) async {
    try {
      _authLoading = AuthLoading.Registering;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print('Error during registration: ${e.toString()}');
      _authLoading = AuthLoading.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithEmailandPassword(String email, String password) async {
    try {
      _authLoading = AuthLoading.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Error during sign: ${e.toString()}');
      _authLoading = AuthLoading.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
