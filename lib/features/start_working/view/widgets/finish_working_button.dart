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
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final AnimationController _textController;
  late final Animation<Offset> _textSlideAnimation;
  double _dragValue = 0.0;
  bool _isDragging = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      _isDragging = true;
      _dragValue += details.delta.dx / constraints.maxWidth;
      _dragValue = _dragValue.clamp(0.0, 1.0);
      _slideController.value = _dragValue;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragValue > 0.7) {
      _slideController.forward();
      setState(() {
        _isCompleted = true;
        _textController.forward();
        widget.onSlideComplete();
      });
    } else {
      _slideController.animateTo(0.0);
    }
    setState(() {
      _isDragging = false;
      _dragValue = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = constraints.maxWidth - 65.0;

        return Container(
          height: 65,
          decoration: BoxDecoration(
            color: _isCompleted ? AppPalette.primary : Colors.white,
            borderRadius: BorderRadius.circular(60),
            border: _isCompleted
                ? null
                : Border.all(color: AppPalette.primary.withOpacity(0.1)),
          ),
          child: Stack(
            children: [
              // Background animation for sliding
              if (_isDragging && !_isCompleted)
                Positioned(
                  left: 3,
                  top: 3,
                  bottom: 3,
                  width: (_slideController.value * buttonWidth) + 56,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppPalette.primary,
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),

              // Animated text
              Center(
                child: _isCompleted
                    ? SlideTransition(
                        position: _textSlideAnimation,
                        child: const Text(
                          'Shift Ended',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        'Finish Working',
                        style: TextStyle(
                          color: _dragValue > 0.35
                              ? Colors.white
                              : AppPalette.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

              // Sliding button
              AnimatedBuilder(
                animation: _slideController,
                builder: (context, child) {
                  return Positioned(
                    left: (_slideController.value * buttonWidth),
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) =>
                          _onDragUpdate(details, constraints),
                      onHorizontalDragEnd: _onDragEnd,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _isCompleted
                                ? Colors.transparent
                                : AppPalette.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
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
