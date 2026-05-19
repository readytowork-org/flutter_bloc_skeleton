import 'package:flutter/material.dart';

class RefreshGridView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final SliverGridDelegate gridDelegate;

  const RefreshGridView({
    super.key,
    required this.onRefresh,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.controller,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        padding: padding,
        controller: controller,
        gridDelegate: gridDelegate,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }
}
