import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:schooly/core/errors/failed_to_load_widget.dart';
import '../../data/datasource/announcements_remote_data_source.dart';
import '../../data/repositories/announcements_repository.dart';
import '../view_models/announcements_cubit.dart';
import '../view_models/announcements_state.dart';
import 'widgets/announcement_card.dart';
import '../../../student_user/presentation/view_models/user_cubit.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnnouncementsCubit(
        AnnouncementsRepository(AnnouncementsRemoteDataSource(Dio())),
      )..getAnnouncements(context.read<UserCubit>().token ?? ''),
      child: const _AnnouncementsBody(),
    );
  }
}

class _AnnouncementsBody extends StatelessWidget {
  const _AnnouncementsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('إعلانات مدرسية'),
        centerTitle: false,
      ),
      body: BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Lottie.asset(
                'assets/animation/loading (2).json',
                width: 120,
                height: 120,
              ),
            );
          }

          // if (state.errorMessage != null) {
          //   return Center(child: Text(state.errorMessage!));
          // }
          if (state.errorMessage != null) {
            return FailedToLoadWidget(
              itemName: 'أعلانات مدرسية❌',
              onRetry: () => context
                  .read<AnnouncementsCubit>()
                  .getAnnouncements(context.read<UserCubit>().token ?? ''),
            );
          }

          if (state.announcements.isEmpty) {
            return const Center(child: Text('لا توجد إعلانات بعد'));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: state.announcements
                .map(
                  (a) => AnnouncementCard(
                    title: a.title,
                    description: a.body,
                    date: a.date,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
