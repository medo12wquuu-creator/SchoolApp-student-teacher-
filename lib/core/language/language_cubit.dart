import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  void changeToArabic() => emit(const Locale('ar'));
  void changeToEnglish() => emit(const Locale('en'));
}
