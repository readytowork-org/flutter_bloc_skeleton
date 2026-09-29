import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_bloc_skeleton/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter_bloc_skeleton/features/auth/presentation/state_management/auth_bloc.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  setUpAll(registerAuthFallbacks);

  late MockAuthBloc authBloc;

  setUp(() {
    authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthState.initial());
    when(() => authBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => authBloc.close()).thenAnswer((_) async {});
  });

  testWidgets('submitting a valid email requests a password reset', (
    tester,
  ) async {
    await tester.pumpApp(const ForgotPasswordPage(), authBloc: authBloc);
    await tester.enterText(
      find.byWidgetPredicate(
        (widget) => widget is FormBuilderTextField && widget.name == 'email',
      ),
      'person@example.com',
    );
    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();

    verify(
      () => authBloc.add(
        const AuthEvent.forgotPasswordRequested(email: 'person@example.com'),
      ),
    ).called(1);
  });

  testWidgets('shows a confirmation after the reset request succeeds', (
    tester,
  ) async {
    whenListen(
      authBloc,
      Stream.fromIterable([
        const AuthState.initial(),
        const AuthState.passwordResetRequested(
          message: 'Check your inbox for a reset link.',
        ),
      ]),
      initialState: const AuthState.initial(),
    );

    await tester.pumpApp(const ForgotPasswordPage(), authBloc: authBloc);
    await tester.pumpAndSettle();

    expect(find.text('Check your email'), findsOneWidget);
    expect(find.text('Check your inbox for a reset link.'), findsOneWidget);
    expect(find.text('Back to login'), findsOneWidget);
  });
}
