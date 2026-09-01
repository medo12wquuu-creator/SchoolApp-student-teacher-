import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_cubit.dart';
import 'package:schooly/features/LOG&REGST/register2/presentation/views/register2.dart';

class OtpPage extends StatefulWidget {
  final String correctOtp; // الكود الصحيح القادم من صفحة Register
  final RegisterCubit registerCubit;

  const OtpPage({
    super.key,
    required this.correctOtp,
    required this.registerCubit,
  });

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final verfiy = AudioPlayer();

  // Controllers لكل خانة
  final List<TextEditingController> controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());

  String numberCode = ""; // الكود الذي يدخله الطالب

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void nextField(String value, int index) {
    if (value.isNotEmpty && index < 4) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  void collectOtp() async {
    // جمع الكود من الخانات الخمسة
    numberCode = controllers.map((c) => c.text).join();
    // ignore: avoid_print
    print("OTP Entered: $numberCode");
    // ignore: avoid_print
    print("Correct OTP: ${widget.correctOtp}");

    // 🔥 المقارنة الأساسية
    if (numberCode == widget.correctOtp) {
      // تشغيل صوت النجاح
      await verfiy.play(AssetSource('sounds/succes.mp3'));
      // نجاح → الانتقال لصفحة Register2
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (_) => Register2Page(registerCubit: widget.registerCubit),
        ),
      );
    } else {
      // فشل → رسالة خطأ
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("الرمز غير صحيح")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,

        title: const Text(
          "رمز التحقق",
          style: TextStyle(color: Color.fromARGB(255, 7, 7, 7)),
        ),
        centerTitle: true,

        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 15, 147, 255),
          fontSize: 22,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/backregister.png', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 17),
                  child: Image.asset(
                    'images/check.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),

                const Wrap(
                  children: [
                    Text(
                      "سوف تستقبل كود من خمسة ارقام \n               .على ايميلك\n           تفحصه واكتبه هنا ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // خانات OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return SizedBox(
                      width: 55,
                      height: 60,
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) => nextField(value, index),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: collectOtp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 205, 228, 255),
                  ),
                  child: const Text(
                    "تحقق",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
