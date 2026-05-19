import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_skeleton/features/auth/presentation/widgets/molecules/login_page_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_bloc_skeleton/features/auth/presentation/state_management/auth_bloc.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  setUpAll(() {
    registerAuthFallbacks();
  });

  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(const AuthState.initial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthBloc.close()).thenAnswer((_) async {});
  });

  // No close() needed for mocks

  group('LoginPageView', () {
    // ── UI rendering ──────────────────────────────────────────────────────────

    testWidgets('shows welcome text, login button, and register button', (
      tester,
    ) async {
      await tester.pumpApp(const LoginPageView(), authBloc: mockAuthBloc);
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back 👋'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    // ── Form validation guard ─────────────────────────────────────────────────

    testWidgets(
      'tapping Login with empty username does NOT call AuthBloc.add',
      (tester) async {
        await tester.pumpApp(const LoginPageView(), authBloc: mockAuthBloc);
        await tester.pumpAndSettle();

        // The form is initially empty
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // AuthBloc must NOT receive any event
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets(
      'tapping Login with valid values fires loginRequested',
      (tester) async {
        await tester.pumpApp(const LoginPageView(), authBloc: mockAuthBloc);
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byWidgetPredicate((w) => w is FormBuilderTextField && w.name == 'username'),
          'test@example.com',
        );
        await tester.enterText(
          find.byWidgetPredicate((w) => w is FormBuilderTextField && w.name == 'password'),
          'password123',
        );

        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        verify(
          () => mockAuthBloc.add(
            const AuthEvent.loginRequested(
              userMap: {'username': 'test@example.com', 'password': 'password123'},
            ),
          ),
        ).called(1);
      },
    );

    // ── AuthState reactions ───────────────────────────────────────────────────

    testWidgets('AuthState.failure shows a SnackBar with the error message', (
      tester,
    ) async {
      whenListen(
        mockAuthBloc,
        Stream.fromIterable([
          const AuthState.initial(),
          const AuthState.failure(message: 'Invalid credentials'),
        ]),
        initialState: const AuthState.initial(),
      );

      await tester.pumpApp(const LoginPageView(), authBloc: mockAuthBloc);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets(
      'AuthState.loading shows CircularProgressIndicator on Login button',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(const AuthState.loading());

        await tester.pumpApp(const LoginPageView(), authBloc: mockAuthBloc);
        await tester.pump(const Duration(milliseconds: 100));

        // Your .withLoading() extension replaces button content with a spinner
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );
  });
}
