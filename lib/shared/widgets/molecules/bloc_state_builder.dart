import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/base_state.dart';
import '../atoms/circular_loading_indicator.dart';

class BlocStateBuilder<B extends BlocBase<S>, S extends BaseState>
    extends StatelessWidget {
  final B Function(B)? addEvent;
  final bool Function(S, S)? buildWhen;
  final bool buildWhenHasNewData;
  final Function(B) onRetry;
  final Widget Function(BuildContext context, S state) onLoaded;
  final Widget? onLoading;
  final String? id;
  final bool hideFallbackWidgets;
  final EdgeInsetsGeometry errorPadding;

  final Widget Function(String message)? onError;

  const BlocStateBuilder({
    super.key,
    required this.onLoaded,
    this.onLoading,
    this.addEvent,
    required this.onRetry,
    this.onError,
    this.hideFallbackWidgets = false,
    this.id,
    this.buildWhen,
    this.errorPadding = EdgeInsets.zero,
    this.buildWhenHasNewData = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen:
          buildWhen ??
          (buildWhenHasNewData
              ? (previous, current) {
                  return current is BaseEmpty || current is BaseFailure
                      ? true
                      : (current is BaseLoaded &&
                            current.res !=
                                (previous is BaseLoaded ? previous.res : null));
                }
              : null),
      bloc: addEvent?.call(context.read<B>()),
      builder: (context, state) {
        return switch (state) {
          BaseInitial() || BaseLoading() =>
            !hideFallbackWidgets
                ? onLoading ?? const Center(child: CircularLoadingIndicator())
                : const SizedBox.shrink(),
          BaseEmpty() =>
            !hideFallbackWidgets
                ? const Center(child: Text("No Data Found"))
                : const SizedBox.shrink(),
          BaseLoaded() => onLoaded(context, state),
          BaseFailure(:final message) =>
            onError != null
                ? onError!(message)
                : Center(
                    child: Padding(
                      padding: errorPadding,
                      child: Text(
                        "Error: $message",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
