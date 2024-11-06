// Toast implementation (previous code)
import 'package:flutter/material.dart';

class ToastOverlay {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
  }) {
    if (_isVisible) {
      _overlayEntry?.remove();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => ToastWidget(
        message: message,
        duration: duration,
        isError: isError,
        onComplete: () {
          hide();
        },
      ),
    );

    _isVisible = true;
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }
}

class ToastWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  final bool isError;
  final VoidCallback onComplete;

  const ToastWidget({
    super.key,
    required this.message,
    required this.duration,
    required this.isError,
    required this.onComplete,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.1, curve: Curves.easeOut),
      reverseCurve: const Interval(0.9, 1.0, curve: Curves.easeIn),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.1, curve: Curves.easeOut),
      reverseCurve: const Interval(0.9, 1.0, curve: Curves.easeIn),
    ));

    _controller.forward().then((_) {
      _controller.reverse().then((_) {
        widget.onComplete();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: widget.isError ? Colors.red.shade800 : Colors.white,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isError
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                widget.message,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: 1 - _controller.value,
                            backgroundColor: widget.isError
                                ? Colors.red.shade900
                                : Colors.green,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.isError
                                  ? Colors.red.shade100
                                  : Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
