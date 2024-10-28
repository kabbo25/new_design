import 'package:flutter/material.dart';
import 'package:new_design/core/theme/app_palette.dart';

class SlidableButton extends StatefulWidget {
  final VoidCallback onSlideComplete;

  const SlidableButton({
    super.key,
    required this.onSlideComplete,
  });

  @override
  State<SlidableButton> createState() => SlidableButtonState();
}

class SlidableButtonState extends State<SlidableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragValue = 0.0;
  bool _isDragging = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      _isDragging = true;
      _dragValue += details.delta.dx / constraints.maxWidth;
      _dragValue = _dragValue.clamp(0.0, 1.0);
      _controller.value = _dragValue;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragValue > 0.7) {
      _controller.forward();
      setState(() {
        _isCompleted = true;
        widget.onSlideComplete();
      });
    } else {
      _controller.animateTo(0.0);
    }
    setState(() {
      _isDragging = false;
      _dragValue = 0.0;
    });
  }

  Color _getBackgroundColor() {
    if (_isCompleted) {
      return AppPalette.primary;
    } else if (_isDragging) {
      return Color.lerp(
        Colors.white,
        AppPalette.primary.withOpacity(0.3),
        _dragValue,
      )!;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth =
            constraints.maxWidth - 56.0; // Accounting for button size

        return Container(
          height: 56,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Stack(
            children: [
              // Slide text
              Center(
                child: Text(
                  _isCompleted ? 'Shift Ended' : 'Finish Working',
                  style: TextStyle(
                    color: _isCompleted ? Colors.white : AppPalette.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Sliding button
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    left: (_controller.value * buttonWidth),
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) =>
                          _onDragUpdate(details, constraints),
                      onHorizontalDragEnd: _onDragEnd,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: _isCompleted
                                ? Colors.transparent
                                : AppPalette.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              _isCompleted ? Icons.check : Icons.arrow_forward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
