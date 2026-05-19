import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum/index.dart';
import '../../bloc/base_pagination_bloc.dart';
import '../atoms/circular_loading_indicator.dart';

class BlocPaginationView<T, B extends BasePaginationBloc<T>>
    extends StatefulWidget {
  final SliverGridDelegate? gridDelegate;
  final Widget Function(BuildContext, T) itemBuilder;
  final List<Widget>? headerSlivers;
  final Widget? loadingIndicator;
  final Widget? emptyView;
  final Widget? errorView;
  final bool showDivider;
  final EdgeInsets? padding;
  final Axis scrollDirection;
  final void Function(int page, List<T> data)? onPageLoaded;

  const BlocPaginationView({
    super.key,
    required this.itemBuilder,
    this.gridDelegate,
    this.headerSlivers,
    this.loadingIndicator,
    this.emptyView,
    this.errorView,
    this.showDivider = true,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.onPageLoaded,
  });

  @override
  State<BlocPaginationView<T, B>> createState() =>
      _BlocPaginationViewState<T, B>();
}

class _BlocPaginationViewState<T, B extends BasePaginationBloc<T>>
    extends State<BlocPaginationView<T, B>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Inject callback into Bloc if provided
    if (widget.onPageLoaded != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<B>().onPageLoaded = widget.onPageLoaded;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // Fetch more data when we are 200 pixels from the bottom
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200) {
      context.read<B>().add(const PaginationFetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, PaginationState<T>>(
      builder: (context, state) {
        // Initial Loading State
        if (state.status == PaginationStatus.initial ||
            (state.status == PaginationStatus.loading && state.data.isEmpty)) {
          return widget.loadingIndicator ??
              const Center(child: CircularLoadingIndicator());
        }

        // Error State (if no data)
        if (state.status == PaginationStatus.failure && state.data.isEmpty) {
          return widget.errorView ??
              Center(child: Text(state.error ?? 'Error loading data'));
        }

        // Empty State
        if (state.data.isEmpty) {
          return widget.emptyView ??
              const Center(child: Text('No items found'));
        }

        // Success State with Data
        return RefreshIndicator(
          onRefresh: () async {
            context.read<B>().add(const PaginationRefresh());
          },
          child: CustomScrollView(
            controller: _scrollController,
            scrollDirection: widget.scrollDirection,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (widget.headerSlivers != null) ...widget.headerSlivers!,
              SliverPadding(
                padding: widget.padding ?? EdgeInsets.zero,
                sliver: widget.gridDelegate != null
                    ? SliverGrid(
                        gridDelegate: widget.gridDelegate!,
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              widget.itemBuilder(context, state.data[index]),
                          childCount: state.data.length,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = widget.itemBuilder(
                            context,
                            state.data[index],
                          );
                          if (widget.showDivider &&
                              index < state.data.length - 1) {
                            return Column(children: [item, const Divider()]);
                          }
                          return item;
                        }, childCount: state.data.length),
                      ),
              ),
              if (!state.hasReachedMax)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularLoadingIndicator()),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
