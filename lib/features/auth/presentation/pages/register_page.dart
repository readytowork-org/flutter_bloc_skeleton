import 'package:flutter/material.dart';

import '../widgets/molecules/register_page_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Page")),
      body: RegisterPageView(),
    );
  }
}
