import 'package:flutter/material.dart';

import '../../../../auth/domain/entities/user_entity.dart';
import '../atoms/profile_avatar.dart';
import '../molecules/profile_header_info.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blueAccent.withValues(alpha: 0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          ProfileAvatar(imageUrl: user.profileUrl),
          const SizedBox(height: 16),
          ProfileHeaderInfo(
            displayName: user.displayName,
            username: user.username,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
