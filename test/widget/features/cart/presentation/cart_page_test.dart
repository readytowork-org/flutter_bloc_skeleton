import 'package:flutter/material.dart';
import 'package:flutter_bloc_skeleton/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter_bloc_skeleton/l10n/s.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CartPage shows AppBar title and empty message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        home: const CartPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Product name'), findsOneWidget); // S.of(context).cartProductName
    expect(find.text('Product'), findsOneWidget); // S.of(context).cartProduct
  });
}
