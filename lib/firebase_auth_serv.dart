import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServ {
  Future<User?> signIn(String email, String pwd) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw "User not found!";
      } else if (e.code == 'wrong-password') {
        throw "Wrong password!";
      }
    }
    return null;
  }
}
