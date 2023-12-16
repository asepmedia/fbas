import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latihan_fbase/pages/dashboard_page.dart';
import 'package:latihan_fbase/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_auth_serv.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final FirebaseAuthServ _authServ = FirebaseAuthServ();

  final _formKey = GlobalKey<FormState>();
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();

  void showLoginAlertMsg(final String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login error"),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text("RETURN"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void firebaseSignin() async {
    String email = EmailController.text;
    String password = PasswordController.text;

    try {
      User? user = await _authServ.signIn(email, password);
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      }
      else {
        showLoginAlertMsg("Login credentials not found");
      }
    } on String catch (e) {
      showLoginAlertMsg(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   "Email",
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                // ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/image/onboarding.png'),
                      width: 100,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Smart Village",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Aplikasi Dari Desa Untuk Desa",
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),

                const SizedBox(height: 70),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: EmailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kolom email kosong";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // const Text(
                //   "Password",
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                // ),
                // const SizedBox(height: 5),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  controller: PasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kolom password kosong";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                  height: 40,
                  onPressed: () async {
                    firebaseSignin();
                  },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
