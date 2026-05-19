import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc_skeleton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify login flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we are on the login page
      expect(find.text('ShopBloc'), findsOneWidget);
      expect(find.text('Welcome Back 👋'), findsOneWidget);

      // Verify form fields exist
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
}
