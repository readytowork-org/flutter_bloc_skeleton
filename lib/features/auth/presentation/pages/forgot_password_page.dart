import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/validators/form_validator.dart';
import '../routes/auth_route_paths.dart';
import '../state_management/auth_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submit() {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final email = _formKey.currentState!.value['email'] as String;
    context.read<AuthBloc>().add(
      AuthEvent.forgotPasswordRequested(email: email.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to login',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  state.maybeWhen(
                    failure: (message) => ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(message))),
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    passwordResetRequested: (message) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.mark_email_read_outlined,
                          size: 64,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Check your email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(message, textAlign: TextAlign.center),
                        const SizedBox(height: 28),
                        ElevatedButton(
                          onPressed: () => context.go(AuthRoute.login.path),
                          child: const Text('Back to login'),
                        ),
                      ],
                    ),
                    orElse: () => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter your email address and we’ll send you a link to reset your password.',
                        ),
                        const SizedBox(height: 28),
                        FormBuilder(
                          key: _formKey,
                          child: FormBuilderTextField(
                            name: 'email',
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            decoration: const InputDecoration(
                              labelText: 'Email address',
                              border: OutlineInputBorder(),
                            ),
                            validator: FormValidator.email,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: state is AuthLoading ? null : _submit,
                            child: state is AuthLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text('Send reset link'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
