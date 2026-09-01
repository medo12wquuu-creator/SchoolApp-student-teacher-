// import 'package:audioplayers/audioplayers.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:schooly/features/LOG&REGST/otp/presentation/views/otp.dart';
// import 'package:schooly/features/LOG&REGST/register/data/datasources/register_remote_data_source.dart';
// import 'package:schooly/features/LOG&REGST/register/data/repositories/register_repository.dart';
// import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_cubit.dart';
// import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_state.dart';
// import 'package:schooly/features/LOG&REGST/register/presentation/views/widget/register1_body.dart';

// class Register extends StatelessWidget {
//   final succes = AudioPlayer();
//   final error = AudioPlayer();

//   Register({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(
//         context,
//       ).unfocus(), // ← يغلق الكيبورد عند الضغط خارج الحقول
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 225, 221, 221),
//         body: BlocProvider(
//           create: (_) => RegisterCubit(
//             RegisterRepository(RegisterRemoteDataSource(Dio())),
//           ),
//           child: BlocConsumer<RegisterCubit, RegisterState>(
//             listener: (context, state) async {
//               if (state is RegisterLoading) {
//                 AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.info,
//                   title: "Processing",
//                   desc: "Please wait...",
//                 ).show();
//               }

//               if (state is RegisterSuccess) {
//                 await succes.play(AssetSource('sounds/succes.mp3'));
//                 AwesomeDialog(
//                   // ignore: use_build_context_synchronously
//                   context: context,
//                   dialogType: DialogType.success,
//                   title: "Sent ✅",
//                   desc: "Your Information is sent successfully!",
//                   btnOkOnPress: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => OtpPage(
//                           correctOtp: state.code,
//                           registerCubit: context.read<RegisterCubit>(),
//                         ),
//                       ),
//                     );
//                   },
//                 ).show();
//               }

//               if (state is RegisterError) {
//                 await Future.delayed(Duration(seconds: 4));

//                 await error.play(AssetSource('sounds/error.mp3'));

//                 AwesomeDialog(
//                   // ignore: use_build_context_synchronously
//                   context: context,
//                   dialogType: DialogType.warning,
//                   title: "Error",
//                   desc: "emai or phon number is used befor!",
//                 ).show();
//               }
//             },
//             builder: (context, state) {
//               return const RegisterBody();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
////////////////
library;

// import 'package:audioplayers/audioplayers.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:schooly/features/LOG&REGST/otp/presentation/views/otp.dart';
// import 'package:schooly/features/LOG&REGST/register/data/datasources/register_remote_data_source.dart';
// import 'package:schooly/features/LOG&REGST/register/data/repositories/register_repository.dart';
// import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_cubit.dart';
// import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_state.dart';
// import 'package:schooly/features/LOG&REGST/register/presentation/views/widget/register1_body.dart';

// class Register extends StatefulWidget {
//   const Register({super.key});

//   @override
//   State<Register> createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   final AudioPlayer succes = AudioPlayer();
//   final AudioPlayer error = AudioPlayer();

//   AwesomeDialog? _loadingDialog;

//   @override
//   void dispose() {
//     succes.dispose();
//     error.dispose();
//     super.dispose();
//   }

//   // =========================================================
//   // إظهار Loading Dialog
//   // =========================================================
//   void _showLoadingDialog(BuildContext context) {
//     // إذا كان هناك Loading Dialog موجود بالفعل
//     // لا ننشئ واحدًا جديدًا
//     if (_loadingDialog != null) {
//       return;
//     }

//     _loadingDialog = AwesomeDialog(
//       context: context,
//       dialogType: DialogType.info,
//       title: "Processing",
//       desc: "Please wait...",
//       dismissOnTouchOutside: false,
//       dismissOnBackKeyPress: false,
//       btnOk: null,
//     );

//     _loadingDialog!.show();
//   }

//   // =========================================================
//   // إغلاق Loading Dialog
//   // =========================================================
//   void _hideLoadingDialog() {
//     if (_loadingDialog != null) {
//       _loadingDialog!.dismiss();
//       _loadingDialog = null;
//     }
//   }

//   // =========================================================
//   // Success Dialog
//   // =========================================================
//   Future<void> _showSuccessDialog(
//     BuildContext context,
//     RegisterSuccess state,
//   ) async {
//     // أول شيء أغلق Loading
//     _hideLoadingDialog();

//     // تشغيل صوت النجاح
//     await succes.play(AssetSource('sounds/succes.mp3'));

//     if (!context.mounted) return;

//     AwesomeDialog(
//       context: context,
//       dialogType: DialogType.success,
//       title: "Sent ✅",
//       desc: "Your information was sent successfully!",
//       btnOkText: "Continue",
//       btnOkOnPress: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => OtpPage(
//               correctOtp: state.code,
//               registerCubit: context.read<RegisterCubit>(),
//             ),
//           ),
//         );
//       },
//     ).show();
//   }

//   // =========================================================
//   // Error Dialog
//   // =========================================================
//   Future<void> _showErrorDialog(BuildContext context) async {
//     // أول شيء أغلق Loading
//     _hideLoadingDialog();

//     // تشغيل صوت الخطأ
//     await error.play(AssetSource('sounds/error.mp3'));

//     if (!context.mounted) return;

//     AwesomeDialog(
//       context: context,
//       dialogType: DialogType.warning,
//       title: "Error",
//       desc: "Email or phone number is already used!",
//       btnOkText: "OK",
//     ).show();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 225, 221, 221),
//         body: BlocProvider(
//           create: (_) => RegisterCubit(
//             RegisterRepository(RegisterRemoteDataSource(Dio())),
//           ),

//           child: BlocConsumer<RegisterCubit, RegisterState>(
//             listener: (context, state) async {
//               // =================================================
//               // LOADING
//               // =================================================
//               if (state is RegisterLoading) {
//                 _showLoadingDialog(context);
//               }
//               // =================================================
//               // SUCCESS
//               // =================================================
//               else if (state is RegisterSuccess) {
//                 await _showSuccessDialog(context, state);
//               }
//               // =================================================
//               // ERROR
//               // =================================================
//               else if (state is RegisterError) {
//                 await _showErrorDialog(context);
//               }
//             },

//             builder: (context, state) {
//               return const RegisterBody();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:schooly/features/LOG&REGST/otp/presentation/views/otp.dart';
import 'package:schooly/features/LOG&REGST/register/data/datasources/register_remote_data_source.dart';
import 'package:schooly/features/LOG&REGST/register/data/repositories/register_repository.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_cubit.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_state.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/views/widget/register1_body.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AudioPlayer succes = AudioPlayer();
  final AudioPlayer error = AudioPlayer();

  AwesomeDialog? _loadingDialog;

  bool _isDialogShowing = false;

  @override
  void dispose() {
    succes.dispose();
    error.dispose();
    super.dispose();
  }

  // =========================================================
  // إغلاق الكيبورد والـ Focus
  // =========================================================
  void _closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // =========================================================
  // Loading Dialog
  // =========================================================
  void _showLoadingDialog(BuildContext context) {
    if (_isDialogShowing) return;

    _isDialogShowing = true;

    _loadingDialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      title: "Processing",
      desc: "Please wait...",
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      btnOk: null,
    );

    _loadingDialog!.show();
  }

  // =========================================================
  // إغلاق Loading Dialog
  // =========================================================
  void _hideLoadingDialog() {
    if (_loadingDialog == null) return;

    _loadingDialog!.dismiss();

    _loadingDialog = null;
    _isDialogShowing = false;
  }

  // =========================================================
  // SUCCESS
  // =========================================================
  Future<void> _showSuccessDialog(
    BuildContext context,
    RegisterSuccess state,
  ) async {
    // أولاً أغلق Loading
    _hideLoadingDialog();

    if (!context.mounted) return;

    // أظهر Success مباشرة
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Sent ✅",
      desc: "Your information was sent successfully!",
      btnOkText: "Continue",
      btnOkOnPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpPage(
              correctOtp: state.code,
              registerCubit: context.read<RegisterCubit>(),
            ),
          ),
        );
      },
    ).show();

    // شغل الصوت بدون انتظار ظهوره
    try {
      await succes.play(AssetSource('sounds/succes.mp3'));
    } catch (e) {
      debugPrint("Success sound error: $e");
    }
  }

  // =========================================================
  // ERROR
  // =========================================================
  Future<void> _showErrorDialog(BuildContext context) async {
    // أولاً أغلق Loading
    _hideLoadingDialog();

    if (!context.mounted) return;

    // أظهر Error مباشرة
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: "Error",
      desc: "Email or phone number is already used!",
      btnOkText: "OK",
    ).show();

    // شغل الصوت بدون انتظار
    try {
      await error.play(AssetSource('sounds/error.mp3'));
    } catch (e) {
      debugPrint("Error sound error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _closeKeyboard();
      },

      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 225, 221, 221),

        body: BlocProvider(
          create: (_) => RegisterCubit(
            RegisterRepository(RegisterRemoteDataSource(Dio())),
          ),

          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              // =================================================
              // LOADING
              // =================================================
              if (state is RegisterLoading) {
                // مهم جداً:
                // أغلق الكيبورد قبل إظهار Dialog
                _closeKeyboard();

                // ثم أظهر Loading
                _showLoadingDialog(context);
              }
              // =================================================
              // SUCCESS
              // =================================================
              else if (state is RegisterSuccess) {
                _showSuccessDialog(context, state);
              }
              // =================================================
              // ERROR
              // =================================================
              else if (state is RegisterError) {
                _showErrorDialog(context);
              }
            },

            builder: (context, state) {
              return const RegisterBody();
            },
          ),
        ),
      ),
    );
  }
}
