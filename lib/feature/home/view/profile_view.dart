import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/bloc/user/user_bloc.dart';
import 'package:shartflix/core/extensions/context_ext.dart';
import 'package:shartflix/core/router/go_router.dart';
import 'package:shartflix/ui/app_ui.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingSmall),
          child: Column(
            children: [
              _buildUserInfoCard(state, context),
            ],
          ),
        );
      },
    );
  }

  Row _buildUserInfoCard(UserState state, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: state.userResponse.data?.photoUrl != null
              ? ClipOval(
                  child: Image.network(
                    state.userResponse.data!.photoUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      );
                    },
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.userResponse.data!.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.profile_view_id_label(state.userResponse.data!.id),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        AppButton.primary(
          text: context.l10n.profile_view_add_photo_button,
          onPressed: () {
            context.goNamed(AppRoute.photoUpload.name);
          },
        ),
      ],
    );
  }
}
