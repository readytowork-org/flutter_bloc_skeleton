import 'package:flutter/material.dart';

import '../../../../shared/widgets/organisms/screen_record_guard.dart';
import '../widgets/molecules/login_page_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RecordingGuard(child: const LoginPageView());
  }
}
