import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_cubit.dart';
import '../../data/models/classroom_model.dart';
import '../../data/repositories/register2_repository.dart';
import 'register2_state.dart';

class Register2Cubit extends Cubit<Register2State> {
  final Register2Repository repository;
  final RegisterCubit registerCubit;

  Register2Cubit(this.repository, this.registerCubit)
    : super(Register2Initial());

  File? profileImage;
  File? identityImage1;
  File? identityImage2;

  String? firstName;
  String? NewClass;
  String? lastName;
  String? fatherName;
  String? motherName;
  DateTime? birthdate;
  List<ClassroomModel> classes = [];
  bool isClassesLoading = false;

  void setProfileImage(File file) => profileImage = file;
  void setIdentityImage1(File file) => identityImage1 = file;
  void setIdentityImage2(File file) => identityImage2 = file;

  void setFirstName(String v) => firstName = v;
  void setNewClass(String v) => NewClass = v;
  void setLastName(String v) => lastName = v;
  void setFatherName(String v) => fatherName = v;
  void setMotherName(String v) => motherName = v;
  void setBirthdate(DateTime v) => birthdate = v;

  Future<void> loadClasses() async {
    if (isClassesLoading) return;

    isClassesLoading = true;
    emit(Register2ClassesLoading());

    try {
      final result = await repository.getClasses();
      classes = result;
      emit(Register2ClassesLoaded(result));
    } catch (e) {
      emit(Register2Error('تعذر جلب الصفوف'));
    } finally {
      isClassesLoading = false;
    }
  }

  Future<void> submit() async {
    if (profileImage == null ||
        identityImage1 == null ||
        identityImage2 == null ||
        firstName == null ||
        lastName == null ||
        fatherName == null ||
        motherName == null ||
        NewClass == null ||
        birthdate == null) {
      emit(Register2Error("كل الحقول مطلوبة"));
      return;
    }

    emit(Register2Loading());

    try {
      final response = await repository.registerUser(
        profileImage: profileImage!,
        id1: identityImage1!,
        last_class_certification: identityImage2!,
        firstName: firstName!,
        lastName: lastName!,
        fatherName: fatherName!,
        motherName: motherName!,
        classWanted: NewClass!,
        birthdate: birthdate!, // 👈 الآن DateTime وليس String
        email: registerCubit.email,
        phone: registerCubit.phone,
        password: registerCubit.password,
      );
      print(
        '🔍 register2 response -> statusCode: ${response.statusCode}, success: ${response.success}, message: ${response.message}',
      );
      if (response.success) {
        emit(Register2Success(response.message));
      } else {
        emit(Register2Error(response.message));
      }
    } catch (e) {
      if (isClosed) return;

      emit(Register2Error(e.toString()));
    }
  }
}
