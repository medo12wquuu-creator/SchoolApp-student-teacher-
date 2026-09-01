import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/views/login.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_cubit.dart';
import 'package:schooly/features/LOG&REGST/register2/data/datasources/register2_remote_data_source.dart';
import 'package:schooly/features/LOG&REGST/register2/data/repositories/register2_repository.dart';
import 'package:schooly/features/LOG&REGST/register2/presentation/views/widget/register2_body.dart';
import '../view_models/register2_cubit.dart';
import '../view_models/register2_state.dart';

class Register2Page extends StatelessWidget {
  const Register2Page({super.key, required this.registerCubit});

  final RegisterCubit registerCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 254, 254, 1),
      body: BlocProvider(
        create: (_) => Register2Cubit(
          Register2Repository(Register2RemoteDataSource(Dio())),
          registerCubit,
        ),
        child: BlocConsumer<Register2Cubit, Register2State>(
          listener: (context, state) {
            if (state is Register2Success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Login()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'انتظر الموافقة على حسابك من قبل الإدارة، من خلال مراجعة بريدك الإلكتروني ',
                  ),
                  duration: Duration(seconds: 4),
                ),
              );
            } else if (state is Register2Error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    // state.message
                    "لا يتوفر اتصال بالإنترنت ، أعد المحاولة مجدداَ",
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return const Register2Body();
          },
        ),
      ),
    );
  }
}
