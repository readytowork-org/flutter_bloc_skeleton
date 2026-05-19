import 'package:flutter/material.dart';
import 'package:flutter_bloc_skeleton/features/auth/presentation/widgets/atoms/login_input_field.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc_skeleton/l10n/s.dart';

void main() {
  late GlobalKey<FormBuilderState> formKey;

  setUp(() {
    formKey = GlobalKey<FormBuilderState>();
  });

  /// Pumps LoginInputField standalone — no Bloc needed here.
  Future<void> pumpInputField(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        home: Scaffold(body: LoginInputField(formKey: formKey)),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('LoginInputField', () {
    // ── Rendering ─────────────────────────────────────────────────────────────

    testWidgets('renders username and password fields', (tester) async {
      await pumpInputField(tester);

      // FormBuilderTextField with name: 'username' and 'password'
      expect(
        find.byWidgetPredicate(
          (w) => w is FormBuilderTextField && w.name == 'username',
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is FormBuilderTextField && w.name == 'password',
        ),
        findsOneWidget,
      );
    });



    // ── Validation: username ──────────────────────────────────────────────────

    testWidgets('empty username fails FormValidator.fullName', (tester) async {
      await pumpInputField(tester);

      await tester.enterText(
        find.byWidgetPredicate(
          (w) => w is FormBuilderTextField && w.name == 'username',
        ),
        '',
      );

      // Trigger validation
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      // Check that an error text appeared somewhere in the tree
      // (the exact string matches your FormValidator.fullName message)
      expect(find.textContaining('required'), findsWidgets);
    });

    // ── Validation: password ──────────────────────────────────────────────────

    testWidgets('empty password fails FormValidator.password', (tester) async {
      await pumpInputField(tester);

      await tester.enterText(
        find.byWidgetPredicate(
          (w) => w is FormBuilderTextField && w.name == 'password',
        ),
        '',
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.textContaining('required'), findsWidgets);
    });

    // ── Valid state ───────────────────────────────────────────────────────────

    testWidgets('valid inputs pass validation and populate formValue', (
      tester,
    ) async {
      await pumpInputField(tester);

      await tester.enterText(
        find.byWidgetPredicate(
          (w) => w is FormBuilderTextField && w.name == 'username',
        ),
        'test@example.com',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (w) => w is FormBuilderTextField && w.name == 'password',
        ),
        'securePass1',
      );

      final isValid = formKey.currentState!.validate();
      formKey.currentState!.save();
      expect(isValid, isTrue);

      final values = formKey.currentState!.value;
      expect(values['username'], 'test@example.com');
      expect(values['password'], 'securePass1');
    });
  });
}
