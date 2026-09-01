import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/LOG&REGST/register2/data/models/classroom_model.dart';
import 'package:schooly/features/LOG&REGST/register2/presentation/view_models/register2_state.dart';
import '../../view_models/register2_cubit.dart';
import 'register2_field.dart';

class Register2Form extends StatefulWidget {
  const Register2Form({super.key});

  @override
  State<Register2Form> createState() => _Register2FormState();
}

class _Register2FormState extends State<Register2Form> {
  final formKey = GlobalKey<FormState>();
  ClassroomModel? selectedClassroom;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final fatherName = TextEditingController();
  final motherName = TextEditingController();
  final birth = TextEditingController();

  Future<void> pickProfile() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      context.read<Register2Cubit>().setProfileImage(File(file.path));
      setState(() {});
    }
  }

  Future<void> pickID1() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      context.read<Register2Cubit>().setIdentityImage1(File(file.path));
      setState(() {});
    }
  }

  Future<void> pickID2() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      context.read<Register2Cubit>().setIdentityImage2(File(file.path));
      setState(() {});
    }
  }

  // Future<void> pickBirthdate() async {
  //   DateTime? date = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime(2005),
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //   );

  //   if (date != null) {
  //     birth.text = "${date.day}/${date.month}/${date.year}";
  //     context.read<Register2Cubit>().setBirthdate(birth.text);
  //     setState(() {});
  //   }
  // }

  Future<void> pickBirthdate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      // 1) خزّن التاريخ داخل TextField كـ String للعرض فقط
      birth.text = "${date.day}/${date.month}/${date.year}";

      // 2) خزّن التاريخ الحقيقي داخل Cubit كـ DateTime
      context.read<Register2Cubit>().setBirthdate(date);

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Register2Cubit>().loadClasses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<Register2Cubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: pickProfile,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: cubit.profileImage != null
                    ? FileImage(cubit.profileImage!)
                    : null,
                child: cubit.profileImage == null
                    ? const Icon(Icons.person, size: 70)
                    : null,
              ),
            ),
            Text(
              "صورة الملف الشخصي",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 20),

            // FIRST NAME
            Register2Field(
              controller: firstName,
              hintText: "الاسم الأول",
              icon: Icons.person,
              obscuretxt: false,
              validator: (v) => v!.isEmpty ? "Required" : null,
              onchange: (v) => cubit.setFirstName(v!),
            ),

            const SizedBox(height: 16),

            // LAST NAME
            Register2Field(
              controller: lastName,
              hintText: "الكنية (الاسم الأخير)",
              icon: Icons.person,
              obscuretxt: false,
              validator: (v) => v!.isEmpty ? "Required" : null,
              onchange: (v) => cubit.setLastName(v!),
            ),

            const SizedBox(height: 16),

            // FATHER NAME
            Register2Field(
              controller: fatherName,
              hintText: "اسم الأب",
              icon: Icons.person,
              obscuretxt: false,
              validator: (v) => v!.isEmpty ? "Required" : null,
              onchange: (v) => cubit.setFatherName(v!),
            ),

            const SizedBox(height: 16),

            // MOTHER NAME
            Register2Field(
              controller: motherName,
              hintText: "اسم الأم",
              icon: Icons.person,
              obscuretxt: false,
              validator: (v) => v!.isEmpty ? "Required" : null,
              onchange: (v) => cubit.setMotherName(v!),
            ),
            const SizedBox(height: 20),

            // if (cubit.isClassesLoading)
            //   const Padding(
            //     padding: EdgeInsets.symmetric(vertical: 12),
            //     child: Center(child: CircularProgressIndicator()),
            //   )
            // else
            //   DropdownMenu<ClassroomModel>(
            //     initialSelection: selectedClassroom,
            //     hintText: 'اختر الصف',

            //     leadingIcon: const Icon(Icons.school),
            //     width: MediaQuery.of(context).size.width - 40,
            //     dropdownMenuEntries: cubit.classes
            //         .map(
            //           (classroom) => DropdownMenuEntry<ClassroomModel>(
            //             value: classroom,
            //             label: classroom.name,
            //           ),
            //         )
            //         .toList(),
            //     onSelected: (value) {
            //       if (value == null) return;
            //       setState(() {
            //         selectedClassroom = value;
            //       });
            //       cubit.setNewClass(value.name);
            //     },
            //   ),
            if (cubit.isClassesLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              DropdownMenu<ClassroomModel>(
                initialSelection: selectedClassroom,
                hintText: 'اختر الصف',
                leadingIcon: const Icon(Icons.school),
                width: MediaQuery.of(context).size.width - 40,
                dropdownMenuEntries: cubit.classes
                    .map(
                      (classroom) => DropdownMenuEntry<ClassroomModel>(
                        value: classroom,
                        label: classroom.name,
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedClassroom = value;
                  });
                  cubit.setNewClass(value.name);
                },
                // هذا الجزء يغير خلفية الحقل فقط
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.blue.shade50, // لون خلفية الحقل
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 198, 215, 229),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // ID IMAGE 1
            ElevatedButton.icon(
              onPressed: pickID1,
              icon: const Icon(Icons.badge),
              label: const Text("ارفع صورة الهوية"),
            ),

            if (cubit.identityImage1 != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(cubit.identityImage1!, height: 120),
              ),

            const SizedBox(height: 20),

            // ID IMAGE 2
            ElevatedButton.icon(
              onPressed: pickID2,
              icon: const Icon(Icons.badge),
              label: const Text("ارفع صورة جلاءك"),
            ),

            if (cubit.identityImage2 != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(cubit.identityImage2!, height: 120),
              ),

            const SizedBox(height: 20),

            // BIRTHDATE
            TextFormField(
              controller: birth,
              readOnly: true,
              onTap: pickBirthdate,
              decoration: const InputDecoration(
                hintText: "تاريخ الميلاد",
                prefixIcon: Icon(Icons.cake),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: cubit.state is Register2Loading
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        cubit.submit();
                      }
                    },
              child: cubit.state is Register2Loading
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("ارسال المعلومات"),
            ),
          ],
        ),
      ),
    );
  }
}
