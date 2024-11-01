import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:new_design/generated/assets.dart';
import 'package:vibration/vibration.dart';

class FeedbackService {
  final bool enableSound;
  final bool enableVibration;
  late AudioPlayer _audioPlayer;
  bool _hasVibrator = false;

  FeedbackService({
    required this.enableSound,
    required this.enableVibration,
  }) {
    _init();
  }

  Future<void> _init() async {
    if (enableSound) {
      _audioPlayer = AudioPlayer();
      await _loadSound();
    }
    if (enableVibration) {
      _hasVibrator = await Vibration.hasVibrator() ?? false;
    }
  }

  Future<void> _loadSound() async {
    try {
      await _audioPlayer.setAsset(Assets.audioTick);
    } catch (e) {
      debugPrint('Error loading sound: $e');
    }
  }

  Future<void> provideFeedback() async {
    await _playSound();
    await _vibrate();
  }

  Future<void> _playSound() async {
    if (!enableSound) return;

    try {
      await _audioPlayer.setVolume(0.03);
      await _audioPlayer.seek(const Duration(milliseconds: 400));
      await _audioPlayer.setClip(
        start: const Duration(milliseconds: 700),
        end: const Duration(milliseconds: 900),
      );
      _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _vibrate() async {
    if (!enableVibration || !_hasVibrator) return;

    try {
      await Vibration.vibrate(duration: 40);
    } catch (e) {
      debugPrint('Error during vibration: $e');
    }
  }

  void dispose() {
    if (enableSound) {
      _audioPlayer.dispose();
    }
  }
}
