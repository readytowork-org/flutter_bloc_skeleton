import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../../product/presentation/routes/product_route_paths.dart';
import '../../state_management/auth_bloc.dart';
import '../../../../../core/utils/extension/common_extension.dart';
import '../atoms/register_input_field.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  final formKey = GlobalKey<FormBuilderState>();

  void onAuthStateListener(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      context.go(ProductRoute.product.path);
    }
  }

  void onSignUpButtonPressed() {
    if (formKey.isValid) {
      context.read<AuthBloc>().add(SignUpRequested(userMap: formKey.formValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: Column(
        spacing: 20,
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        children: [
          const Text("Welcome to Register Page"),
          RegisterInputField(formKey: formKey),
          BlocConsumer<AuthBloc, AuthState>(
            listener: onAuthStateListener,
            builder: (context, state) {
              return ElevatedButton(
                onPressed: onSignUpButtonPressed,
                child: const Text("Register"),
              ).withLoading(state is AuthLoading);
            },
          ),
        ],
      ),
    );
  }
}
