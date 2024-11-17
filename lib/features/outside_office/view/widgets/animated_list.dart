import 'package:flutter/material.dart';

class AnimatedScrollList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item, double opacity) itemBuilder;
  final double maxHeight;
  final ScrollController? scrollController;
  final bool showScrollbar;
  final double itemHeight;
  final bool debug; // Add debug mode

  const AnimatedScrollList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.maxHeight,
    this.scrollController,
    this.showScrollbar = true,
    this.itemHeight = 100.0,
    this.debug = false, // Default to false
  });

  @override
  State<AnimatedScrollList<T>> createState() => _AnimatedScrollListState<T>();
}

class _AnimatedScrollListState<T> extends State<AnimatedScrollList<T>> {
  late ScrollController _scrollController;
  double scrollOffset = 0;
  final GlobalKey _listKey = GlobalKey();
  final Map<int, double> _itemHeights = {};

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);

    if (widget.debug) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _measureItemHeights();
      });
    }
  }

  void _measureItemHeights() {
    final RenderBox? renderBox =
        _listKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    for (int i = 0; i < widget.items.length; i++) {
      final itemKey = GlobalKey();
      _itemHeights[i] = renderBox.size.height / widget.items.length;
    }

    if (widget.debug) {
      print(
          'Average item height: ${_itemHeights.values.isNotEmpty ? _itemHeights.values.reduce((a, b) => a + b) / _itemHeights.length : 0}');
      print('Item heights: $_itemHeights');
    }
  }

  void _onScroll() {
    setState(() {
      scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  double _calculateOpacity(int index) {
    double itemPosition = index * widget.itemHeight;
    double opacity = 1.0;

    if (scrollOffset > itemPosition) {
      opacity = 1.0 - ((scrollOffset - itemPosition) / widget.itemHeight);
    }

    return opacity.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: widget.showScrollbar,
        thickness: 6,
        radius: const Radius.circular(10),
        child: ListView.builder(
          key: _listKey,
          controller: _scrollController,
          itemCount: widget.items.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final opacity = _calculateOpacity(index);

            Widget itemWidget = Opacity(
              opacity: opacity,
              child: Transform(
                transform: Matrix4.identity()..scale(0.8 + (0.2 * opacity)),
                alignment: Alignment.topCenter,
                child: Align(
                  heightFactor: 0.9,
                  child: widget.itemBuilder(item, opacity),
                ),
              ),
            );

            if (widget.debug) {
              itemWidget = Container(
                key: GlobalKey(),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: itemWidget,
              );
            }

            return itemWidget;
          },
        ),
      ),
    );
  }
}
