import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/extension/context_extension/dialog_extension.dart';
import '../../../../../core/utils/extension/context_extension/theme_extension.dart';
import '../../../../../core/utils/index.dart';
import '../../../../../shared/widgets/molecules/app_bloc_button.dart';
import '../../../../auth/auth.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../molecules/profile_info_card.dart';

class ProfileDetailsSection extends StatelessWidget {
  final UserEntity user;

  const ProfileDetailsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Text(
              'Profile Information',
              style: context.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ProfileInfoCard(
              icon: Icons.email_outlined,
              title: 'Email Address',
              value: user.email,
            ),
            const SizedBox(height: 16),
            ProfileInfoCard(
              icon: Icons.person_outline,
              title: 'Gender',
              value: "N/A",
            ),

            const SizedBox(height: 16),

            AppBlocButton<AuthBloc, AuthState>(
              bloc: context.read<AuthBloc>(),
              label: "Logout",
              onTap: (bloc) => bloc.add(LogoutRequested()),
              listener: (context, state) {
                state.maybeWhen(
                  unauthenticated: (message) {
                    context.showSnackBar(message ?? "Logged out");
                  },
                  failure: (message) => context.showSnackBar(message),
                  orElse: () {},
                );
              },
              isLoading: (state) => state is AuthLoading,
              variant: ButtonVariant.outlined,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
