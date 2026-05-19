import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum/index.dart';
import '../atoms/app_button.dart';

/// A generic BLoC-aware button molecule.
/// [B] is the Bloc type, [S] is the State type.

/// CONDITION & USE CASE:
///
/// 1. BlocProvider.value (autoClose == false):
///    USE CASE: When the BLoC is a Singleton (from GetIt) or provided by a parent.
///    WHY: It prevents the 'Cannot add new events after calling close' error because
///    it does NOT dispose of the BLoC when this widget is destroyed.
///
/// 2. BlocProvider (autoClose == true):
///    USE CASE: When the BLoC is created locally for this specific button/section.
///    WHY: It automatically calls bloc.close() to prevent memory leaks.
class AppBlocButton<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  final B bloc;
  final String label;
  final ButtonVariant variant;
  final IconData? icon;
  final Color? color;
  final bool isFullWidth;

  /// If [autoClose] is true, the widget uses 'BlocProvider(create: ...)' and
  /// will call bloc.close() when the button is disposed.
  /// If false (default), it uses 'BlocProvider.value' to keep the BLoC alive.
  final bool autoClose;

  final void Function(BuildContext context, S state) listener;
  final void Function(B bloc) onTap;
  final bool Function(S state) isLoading;
  final bool Function(S state)? isDisabled;

  const AppBlocButton({
    super.key,
    required this.bloc,
    required this.label,
    required this.onTap,
    required this.listener,
    required this.isLoading,
    this.isDisabled,
    this.variant = ButtonVariant.elevated,
    this.icon,
    this.color,
    this.isFullWidth = false,
    this.autoClose = false, // Default to false for Singletons/DI
  });

  @override
  Widget build(BuildContext context) {
    if (autoClose) {
      return BlocProvider<B>(
        create: (context) => bloc,
        child: _buildConsumer(),
      );
    }

    return BlocProvider<B>.value(value: bloc, child: _buildConsumer());
  }

  Widget _buildConsumer() {
    return BlocConsumer<B, S>(
      listener: listener,
      builder: (context, state) {
        final loading = isLoading(state);

        // Safety check: Cast to Bloc to check closed status
        final bool isClosed = (bloc as Bloc).isClosed;
        final bool disabled = isDisabled?.call(state) ?? false;

        return AppButton(
          label: label,
          variant: variant,
          color: color,
          isFullWidth: isFullWidth,
          // Prevent interactions if the BLoC is closed or state is disabled
          onPressed: (isClosed || disabled || loading)
              ? null
              : () => onTap(bloc),
          loading: loading,
          icon: icon,
        );
      },
    );
  }
}
