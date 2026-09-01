import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/classes_body.dart';

class Classes extends StatelessWidget {
  const Classes({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ClassesBody());
  }
}
