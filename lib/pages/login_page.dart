import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latihan_fbase/pages/dashboard_page.dart';
import 'package:latihan_fbase/widgets/button_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();

  final _passwordC = TextEditingController();

  bool _isLoading = false;

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
                TextField(
                  controller: _emailC,
                  onSubmitted: (value) {},
                  onTap: () {},
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
                ),
                const SizedBox(height: 15),
                // const Text(
                //   "Password",
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                // ),
                // const SizedBox(height: 5),
                TextField(
                  controller: _passwordC,
                  onSubmitted: (value) {},
                  onTap: () {},
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
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                  height: 40,
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    var db = FirebaseFirestore.instance;

                    try {
                      var data = await db
                          .collection('users')
                          .where('email', isEqualTo: _emailC.text)
                          .where('password', isEqualTo: _passwordC.text)
                          .get();

                      if (data.docs.first.exists) {
                        const snackBar = SnackBar(
                          content: Text('Berhasil Login'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        _emailC.clear();
                        _passwordC.clear();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const DashboardPage()),
                        );
                      } else {
                        const snackBar = SnackBar(
                          content: Text('User tidak ditemukan'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      const snackBar = SnackBar(
                        content: Text('User tidak ditemukan'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
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
