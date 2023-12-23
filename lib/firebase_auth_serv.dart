import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServ {
  Future<User?> signIn(String email, String pwd) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      return credential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
