import 'package:flutter/material.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/views/register1.dart';
// import 'package:myproj/Login2.dart';
import 'onboarding2.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text("1 of 3", style: TextStyle(fontSize: 16)),
        ),

        // automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 1 / 3,
            color: Colors.blue,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ),

      body: Column(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(height: 200),
          //  const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Welcome to the Al Qimmah School👋          This application is designed for students & teachers of Al Saada School.",
              // .tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Container(height: 235),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingPage2()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                "continue",
                // .tr(),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 10),

          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Register()),
              );
            },
            child: Text("skip", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
