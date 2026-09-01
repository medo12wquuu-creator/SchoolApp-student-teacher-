import 'package:bloc/bloc.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_attendance/student.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_attendance/take_attendance.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';

part 'fetch_atendance_state.dart';

class FetchAtendanceCubit extends Cubit<FetchAtendanceState> {
  final ClassDetailsRepo classDetailsRepo;
  FetchAtendanceCubit(this.classDetailsRepo) : super(FetchAtendanceInitial());

  Future<void> fetchAttendance({required String sectionId}) async {
    emit(FetchAtendanceLoading());
    try {
      var response = await classDetailsRepo.fetchAttendance(
        sectionId: sectionId,
      );

      response.fold(
        (failure) => emit(FetchAtendanceFailure(failure.errMassage)),
        (data) {
          final statusMap = <int, bool>{};
          List<Student> resolvedStudents = [];

          final session = data.session;
          final attendances = session?.attendances ?? [];
          final mainStudents = data.students ?? [];

          // 🟢 1. حالة: تم أخذ الحضور مسبقاً اليوم (وجود session و attendances)
          if (session != null && attendances.isNotEmpty) {
            for (final att in attendances) {
              if (att.student != null) {
                resolvedStudents.add(att.student!);
                final studentId = att.studentId ?? att.student?.id;
                if (studentId != null) {
                  statusMap[studentId] = (att.status == 'present');
                }
              }
            }
          }
          // 🟢 2. حالة: لم يتم أخذ الحضور بعد اليوم (الاعتماد على قائمة الطلاب العامة)
          else if (mainStudents.isNotEmpty) {
            resolvedStudents = List.from(mainStudents);
            for (final student in resolvedStudents) {
              if (student.id != null) {
                statusMap[student.id!] = true; // تعيين "حاضر" افتراضياً
              }
            }
          }

          emit(
            FetchAtendanceSuccess(
              data: data,
              studentsList: resolvedStudents,
              attendanceStatus: statusMap,
            ),
          );
        },
      );
    } catch (e) {
      emit(FetchAtendanceFailure(e.toString()));
    }
  }

  Future<void> submitAttendance({required String sectionId}) async {
    final current = state;
    if (current is! FetchAtendanceSuccess) return;
    if (current.data.session != null) return;

    emit(FetchAtendanceSaving());

    final attendances = current.attendanceStatus.entries.map((e) {
      return {
        'student_id': e.key.toString(),
        'status': e.value ? 'present' : 'absent',
      };
    }).toList();

    try {
      var response = await classDetailsRepo.takeAttendance(
        sectionId: sectionId,
        attendances: attendances,
      );
      response.fold(
        (failure) => emit(FetchAtendanceSaveFailure(failure.errMassage)),
        (_) => emit(FetchAtendanceSaveSuccess()),
      );
    } catch (e) {
      emit(FetchAtendanceSaveFailure(e.toString()));
    }
  }

  void toggleAttendance(int studentId, {bool force = false}) {
    final current = state;
    if (current is! FetchAtendanceSuccess) return;

    // يمنع التعديل إذا كان الحضور قد تم أخذه وتسجيله مسبقاً
    // إلا في وضع التعديل (force = true)
    if (current.data.session != null && !force) return;

    final updated = Map<int, bool>.from(current.attendanceStatus);
    updated[studentId] = !(updated[studentId] ?? true);

    emit(
      FetchAtendanceSuccess(
        data: current.data,
        studentsList: current.studentsList,
        attendanceStatus: updated,
      ),
    );
  }
}