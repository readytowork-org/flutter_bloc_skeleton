import 'package:flutter/material.dart';

import '../../../../shared/widgets/molecules/bloc_state_builder.dart';
import '../state_management/get_profile_bloc/get_profile_bloc.dart';
import '../widgets/organisms/profile_details_section.dart';
import '../widgets/organisms/profile_header.dart';
import '../../../optimization/presentation/routes/optimization_routes.dart';
import 'package:go_router/go_router.dart';

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
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Data & Storage Optimization'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(OptimizationRoutes.optimizationSettings),
                ),
              ],
            );
          },
          onRetry: (bloc) => bloc.add(GetProfileRequested()),
        ),
      ),
    );
  }
}
