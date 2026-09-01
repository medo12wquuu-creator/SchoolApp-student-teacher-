import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/text_styless.dart';
import 'package:schooly/core/helpers/photo_url.dart';
import 'package:schooly/core/services/firebaseteacher.dart';
import 'package:schooly/features/TEACHER/notificationOuter/presentation/views/notification_launcher.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/fetch_teacher_profile_model/fetch_teacher_profile_model.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/fetch_teacher_profile_info/fetch_profile_info_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_profile/presentation/views/teacher_profile_home.dart';

class TeacherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TeacherAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchProfileInfoCubit, FetchProfileInfoState>(
      builder: (context, state) {
        String name = '...';
        String? photoUrl;
        FetchTeacherProfileModel? profileModel;

        if (state is FetchProfileInfoSuccess) {
          profileModel = state.profile;
          final person = state.profile.teacher?.employee?.user?.person;
          final firstName = person?.firstName ?? '';
          final lastName = person?.lastName ?? '';
          name = '$firstName $lastName'.trim();
          if (name.isEmpty) name = '...';
          photoUrl = cacheBustedPhotoUrl(
            person?.personalPhoto,
            person?.updatedAt,
          );
        }

        return AppBar(
          backgroundColor: kwhiteColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleSpacing: 16,
          title: GestureDetector(
            onTap: () {
              Get.to(
                () => BlocProvider.value(
                  value: BlocProvider.of<FetchProfileInfoCubit>(context),
                  child: TeacherProfileHome(profileModel: profileModel),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kprimeryColor, kseconderyColor],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kprimeryColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: klightPrimeryColor,
                    child: photoUrl != null && photoUrl.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: photoUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              httpHeaders: const {
                                'ngrok-skip-browser-warning': 'true',
                                'User-Agent': 'flutter-app',
                              },
                              placeholder: (context, url) => const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: kprimeryColor,
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                color: kprimeryColor,
                                size: 22,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            color: kprimeryColor,
                            size: 22,
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: Styles.textStyle17.copyWith(
                        color: ktextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, left: 16.0),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: klightSecoderyColor.withOpacity(0.4),
                  shape: BoxShape.circle,
                  border: Border.all(color: ktextColor.withOpacity(0.06)),
                ),
                child: ValueListenableBuilder<int>(
                  valueListenable:
                      FirebaseNotificationService.instance.unreadCountNotifier,
                  builder: (context, unreadCount, child) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            color: kseconderyColor,
                            size: 19,
                          ),
                          onPressed: () => openNotificationPage(context),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                unreadCount > 99
                                    ? '99+'
                                    : unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: ktextColor.withOpacity(0.05)),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
