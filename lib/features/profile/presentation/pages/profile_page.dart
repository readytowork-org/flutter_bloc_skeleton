import 'package:flutter/material.dart';

import '../../../../shared/widgets/molecules/bloc_state_builder.dart';
import '../state_management/get_profile_bloc/get_profile_bloc.dart';
import '../widgets/organisms/profile_details_section.dart';
import '../widgets/organisms/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: BlocStateBuilder<GetProfileBloc, GetProfileState>(
          onLoaded: (context, state) {
            final user = (state as ProfileLoaded).res;
            return Column(
              children: [
                ProfileHeader(user: user),
                ProfileDetailsSection(user: user),
              ],
            );
          },
          onRetry: (bloc) => bloc.add(GetProfileRequested()),
        ),
      ),
    );
  }
}
