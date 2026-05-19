import 'package:flutter/material.dart';

class RefreshListView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController? controller;
  final bool showDivider;
  final Widget separatorWidget;
  final EdgeInsets? padding;

  const RefreshListView({
    super.key,
    required this.onRefresh,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.separatorWidget = const SizedBox(),
    this.showDivider = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: padding,
        controller: controller,
        itemBuilder: itemBuilder,
        separatorBuilder: (_, i) =>
            showDivider ? const Divider() : separatorWidget,
        itemCount: itemCount,
      ),
    );
  }
}
