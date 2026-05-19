import 'package:flutter/material.dart';
import 'package:flutter_bloc_skeleton/features/auth/presentation/state_management/auth_bloc.dart';
import 'package:flutter_bloc_skeleton/features/auth/presentation/widgets/molecules/login_page_view.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bloc_skeleton/features/auth/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  setUpAll(() {
    registerAuthFallbacks();
  });

  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    // Always provide a default state
    when(() => mockAuthBloc.state).thenReturn(const AuthState.initial());
  });

  // No close() needed for mocks

  group('LoginPage', () {
    testWidgets('renders Scaffold and AppBar with correct title', (
      tester,
    ) async {
      await tester.pumpApp(const LoginPage(), authBloc: mockAuthBloc);
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.text('ShopBloc'), findsOneWidget); // App Name in body
    });

    testWidgets('renders LoginPageView as body', (tester) async {
      await tester.pumpApp(const LoginPage(), authBloc: mockAuthBloc);
      await tester.pumpAndSettle();

      expect(find.byType(LoginPageView), findsOneWidget);
    });
  });
}
