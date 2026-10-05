import 'package:flutter/material.dart';

class ProfileHeaderInfo extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String username;

  const ProfileHeaderInfo({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          '$firstName $lastName',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '@$username',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
