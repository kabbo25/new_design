import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class FlipTimer extends StatefulWidget {
  const FlipTimer({super.key});

  @override
  State<FlipTimer> createState() => _FlipTimerState();
}

class _FlipTimerState extends State<FlipTimer> {
  late Timer timer;
  late DateTime countToDate;
  Map<String, int> timeLeft = {
    'hours': 0,
    'minutes': 0,
    'seconds': 0,
  };
  Map<String, int> previousTime = {
    'hours': 0,
    'minutes': 0,
    'seconds': 0,
  };

  @override
  void initState() {
    super.initState();
    countToDate = DateTime.now().add(const Duration(hours: 24));
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      final now = DateTime.now();
      final difference = countToDate.difference(now);

      setState(() {
        previousTime = Map.from(timeLeft);
        timeLeft = {
          'hours': difference.inHours,
          'minutes': difference.inMinutes.remainder(60),
          'seconds': difference.inSeconds.remainder(60),
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F1ED),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSegment('Hours', timeLeft['hours']!, previousTime['hours']!),
          const SizedBox(width: 20),
          _buildSegment(
              'Minutes', timeLeft['minutes']!, previousTime['minutes']!),
          const SizedBox(width: 20),
          _buildSegment(
              'Seconds', timeLeft['seconds']!, previousTime['seconds']!),
        ],
      ),
    );
  }

  Widget _buildSegment(String title, int value, int previousValue) {
    final tens = value ~/ 10;
    final ones = value % 10;
    final previousTens = previousValue ~/ 10;
    final previousOnes = previousValue % 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFDE4848),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            FlipCard(
              key: ValueKey('$title-tens-$tens'),
              newValue: tens,
              previousValue: previousTens,
            ),
            const SizedBox(width: 4),
            FlipCard(
              key: ValueKey('$title-ones-$ones'),
              newValue: ones,
              previousValue: previousOnes,
            ),
          ],
        ),
      ],
    );
  }
}

class FlipCard extends StatelessWidget {
  final int newValue;
  final int previousValue;

  const FlipCard({
    super.key,
    required this.newValue,
    required this.previousValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 90,
      child: Stack(
        children: [
          // Top half
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 45,
            child: TopHalf(
              value: newValue,
            ),
          ),

          // Animated parts when value changes
          if (newValue != previousValue) ...[
            TopFlip(
              key: ValueKey('top-$newValue'),
              startValue: previousValue,
              endValue: newValue,
            ),
          ],
        ],
      ),
    );
  }
}

class TopHalf extends StatelessWidget {
  final int value;

  const TopHalf({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      alignment: Alignment.center,
      child: Text(
        value.toString(),
        style: const TextStyle(
          fontSize: 36,
          color: Color(0xFFDE4848),
        ),
      ),
    );
  }
}

class TopFlip extends StatefulWidget {
  final int startValue;
  final int endValue;

  const TopFlip({
    super.key,
    required this.startValue,
    required this.endValue,
  });

  @override
  State<TopFlip> createState() => _TopFlipState();
}

class _TopFlipState extends State<TopFlip> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 250),
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
          height: 45,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-animation.value * pi / 2),
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF7F7F7),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.startValue.toString(),
                style: const TextStyle(
                  fontSize: 36,
                  color: Color(0xFFDE4848),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
