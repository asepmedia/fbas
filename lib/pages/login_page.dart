import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latihan_fbase/widgets/button_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  onSubmitted: (value) {},
                  onTap: () {},
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
                    var db = FirebaseFirestore.instance;
                    // await db.collection('users').add({
                    //   'name': 'Asep',
                    //   'email': 'asep@gmail.com',
                    //   'password': '123456',
                    // });
                    var data = db.collection('users').where({
                      'email': 'asep@gmail.com',
                      'password': '123456',
                    }).count();
                    print(data);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //       builder: (context) => const DashboardPage()),
                    // );
                  },
                  child: const Text('Masuk'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
