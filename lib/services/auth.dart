import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:project_app1/incident_report/models/report_model.dart';
import 'package:project_app1/models/app_user.dart';
import 'package:project_app1/services/auth_exception.dart';
import 'package:project_app1/services/database.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AuthResultStatus _authStatus;

  Stream<AppUser?> get appUser {
    return _auth.userChanges().map(_appUserFromFirebaseUser);
  }

  AppUser? _appUserFromFirebaseUser(User? user) {
    return user != null
        ? AppUser(uid: user.uid, emailVerified: user.emailVerified)
        : null;
  }

  Future<Map<String, dynamic>?> get claims async {
    final user = _auth.currentUser;
    if (user != null) {
      final token = await user.getIdTokenResult(true);
      print('User claims: ${token.claims}'); // Debug print
      return token.claims;
    }
    return null;
  }

  Future<AuthResultStatus> registerWithEmail(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String role}) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;
      if (user != null) {
        await DatabaseService(uid: user.uid)
            .updateProfileName(firstName, lastName, role);
        _authStatus = AuthResultStatus.successful;
      } else {
        _authStatus = AuthResultStatus.undefined;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        _authStatus = AuthResultStatus.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        _authStatus = AuthResultStatus.emailAlreadyExists;
      } else {
        _authStatus = AuthExceptionHandler.handleException(e);
      }
    } catch (e) {
      print('Registration Exception: $e');
      _authStatus = AuthExceptionHandler.handleException(e);
    }
    notifyListeners();
    return _authStatus;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<AuthResultStatus> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;
      if (user != null) {
        _authStatus = AuthResultStatus.successful;
      } else {
        _authStatus = AuthResultStatus.undefined;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _authStatus = AuthResultStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        _authStatus = AuthResultStatus.wrongPassword;
      } else if (e.code == 'too-many-requests') {
        _authStatus = AuthResultStatus.tooManyRequests;
      } else {
        _authStatus = AuthExceptionHandler.handleException(e);
      }
    } catch (e) {
      print('Login Exception: $e');
      _authStatus = AuthExceptionHandler.handleException(e);
    }
    notifyListeners();
    return _authStatus;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> submitIncidentReport(IncidentReport report) async {
  final user = _auth.currentUser;
  String reportId;
  if (user != null) {
    report = report.copyWith(userId: user.uid);
    reportId = (await DatabaseService(uid: user.uid).submitIncidentReport(report)) as String;
  } else {
    reportId = (await DatabaseService(uid: 'anonymous').submitIncidentReport(report)) as String;
  }
  return reportId;
}
  getUserRole() {}
}
