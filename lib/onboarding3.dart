import 'package:flutter/material.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/views/register1.dart';
// import 'package:myproj/Login2.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        title: Text("3 of 3", style: TextStyle(fontSize: 16)),
        // automaticallyImplyLeading: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 3 / 3,
            color: Colors.blue,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ),

      body: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(height: 200),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "DEER TEACHER 👨‍🏫:                                  You can see your students, mark their progress, follow their progree, provide your feedback, and you can see your personal information",
              // .tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(height: 190),

          // const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(builder: (_) => LoginScreen2()),
                //   (route) => false,
                // );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Register()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 2),

          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Register()),
              );
            },
            child: const Text("Skip", style: TextStyle(color: Colors.black)),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
