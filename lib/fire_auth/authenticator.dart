// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future signUp(String email, String password, String username) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final fireUser = credential.user;
    final logger = (await FirebaseFirestore.instance
            .collection("User Data")
            .where("id", isEqualTo: fireUser?.uid)
            .get())
        .docs;
    if (logger.isEmpty) {
      print("New User -- Initializing Cloud Collection....");
      var times = DateTime.now().toString().substring(0,19);
      auth.currentUser!.updateDisplayName(username);
      FirebaseFirestore.instance
          .collection("User Data")
          .doc("$username||${fireUser!.uid}")
          .set({
        "Name": username,
        "Email": email,
        "Password": password,
        "Created Time": DateTime.now().toString().substring(0, 16),
        "Last SignedIn": DateTime.now().toString().toString().substring(0, 16),
        "id": fireUser.uid,
        "Logged In": true,
      }).whenComplete(() => {

      FirebaseFirestore.instance.collection("User Tasks").doc("$username||${fireUser.uid}").collection("Categories").doc(times).set(
          {
            "Category":"Welcome",
            "Created Time":times,
            "Tasks":["Create Your first Task"],
            "Checker":[false],
            "Count":1,
            "id":times,
            "Category Count":1,
            "Completed Tasks":0,
          }),

      });
      sharedPreferences.setString("id", fireUser.uid);
      sharedPreferences.setString("Name", username);
      sharedPreferences.setString("Email", email);
      sharedPreferences.setString("Password", password);
      sharedPreferences.setString("LoggedIn", "true");
      print(sharedPreferences.getString("LoggedIn"));
    }
  } catch (error) {
    print("error found: $error");
    if (error.toString() ==
        "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
      return error.toString();
    } else {
      return null;
    }
  }
}

Future logIn(
  String email,
  String password,
) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final fireUser = credential.user;
    final logger = (await FirebaseFirestore.instance
            .collection("User Data")
            .where("id", isEqualTo: fireUser!.uid)
            .get())
        .docs;
    if (logger.isNotEmpty) {
      print("Old User Signing...");
      sharedPreferences.setString("id", logger[0]["id"]);
      sharedPreferences.setString("Name", logger[0]["Name"]);
      sharedPreferences.setString("Email", logger[0]["Email"]);
      sharedPreferences.setString("Password", logger[0]["Password"]);
      sharedPreferences.setString("LoggedIn", "true");
    }
  } catch (e) {
    if (e.toString() ==
            "[firebase_auth/wrong-password] The password is invalid or the user does not have a password." ||
        e.toString() ==
            "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
      return e.toString();
    } else {
      return null;
    }
  }
}
