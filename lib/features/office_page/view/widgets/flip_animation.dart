import 'dart:math';
import 'package:flutter/material.dart';

class NumberFlip extends StatelessWidget {
  final String newValue;
  final String previousValue;

  const NumberFlip({
    Key? key,
    required this.newValue,
    required this.previousValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,  // Match the reference width
      height: 50,  // Match the reference height
      child: Stack(
        children: [
          // Static parts
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 50,  // Half of the total height
            child: _TopHalf(
              value: newValue,
            ),
          ),
          // Animated parts
          if (newValue != previousValue)
            _TopFlip(
              key: ValueKey('flip-$newValue'),
              startValue: previousValue,
              endValue: newValue,
            ),
        ],
      ),
    );
  }
}

class _TopHalf extends StatelessWidget {
  final String value;

  const _TopHalf({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 36,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _TopFlip extends StatefulWidget {
  final String startValue;
  final String endValue;

  const _TopFlip({
    Key? key,
    required this.startValue,
    required this.endValue,
  }) : super(key: key);

  @override
  State<_TopFlip> createState() => _TopFlipState();
}

class _TopFlipState extends State<_TopFlip> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),  // Match reference timing
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 50,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-animation.value * pi / 2),
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF7F7F7),
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.startValue,
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}