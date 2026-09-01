import 'package:flutter/material.dart';

class OptionModel {
  TextEditingController controller = TextEditingController();
  bool isCorrect;

  OptionModel({String text = '', this.isCorrect = false}) {
    controller.text = text;
  }
}

class QuestionModel {
  TextEditingController bodyController = TextEditingController();
  TextEditingController marksController = TextEditingController(text: '1');
  List<OptionModel> options = [];

  QuestionModel() {
    options.add(OptionModel());
    options.add(OptionModel());
  }
}
