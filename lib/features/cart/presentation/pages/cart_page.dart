import 'package:flutter/material.dart';

import '../../../../l10n/s.dart';
import '../widgets/molecules/cart_page_view.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).cartProductName)),
      body: const CartPageView(),
    );
  }
}
