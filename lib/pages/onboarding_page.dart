import 'package:flutter/material.dart';
import 'package:latihan_fbase/pages/login_page.dart';
import 'package:latihan_fbase/widgets/button_widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Image(
                      image: AssetImage('assets/image/onboarding.png'),
                      width: 220,
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Temukan Layanan\nTerbaik Untuk Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                ButtonWidget(
                  onPressed: () async {
                    // var db = FirebaseFirestore.instance;
                    // await db.collection('users').add({
                    //   'name': 'Asep',
                    //   'email': 'asep@gmail.com',
                    //   'password': '123456',
                    // });
                    // var data = await db.collection('users').get();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('Mulai'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
