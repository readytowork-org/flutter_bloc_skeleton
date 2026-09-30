import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extension/context_extension/theme_extension.dart';
import '../../cubit/locale_cubit.dart';

class LocaleSwitcher extends StatefulWidget {
  final Widget child;

  const LocaleSwitcher({super.key, required this.child});

  @override
  State<LocaleSwitcher> createState() => _LocaleSwitcherState();
}

class _LocaleSwitcherState extends State<LocaleSwitcher> {
  double top = 200;
  double right = 16;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state;
    final isJa = locale.languageCode == 'ja';

    return Stack(
      children: [
        widget.child,

        Positioned(
          top: top,
          right: right,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                top += details.delta.dy;
                right -= details.delta.dx;
              });
            },
            child: FloatingActionButton.small(
              heroTag: 'locale_switcher',
              backgroundColor: isJa ? Colors.pinkAccent : Colors.green,

              onPressed: () {
                context.read<LocaleCubit>().setLocale(isJa ? 'en' : 'ja');
              },

              child: Text(isJa ? 'JA' : 'EN', style: context.bodyLarge),
            ),
          ),
        ),
      ],
    );
  }
}
