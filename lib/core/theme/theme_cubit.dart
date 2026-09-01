import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    // them();

    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  // Color them() {
  //   if (ThemeMode == ThemeMode.light) {
  //     return Colors.white;
  //   }
  //   return Colors.black;
  // }
}
