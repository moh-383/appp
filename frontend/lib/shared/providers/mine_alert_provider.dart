import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/api/rover_api.dart';
import '../utils/mine_status.dart';

class MineAlertProvider extends ChangeNotifier {
  MineAlertProvider(this._api);

  final RoverApi _api;
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;
  bool mineDetected = false;
  String mineStatus = 'Aucune donnée';
  bool _wasDetected = false;
  bool _bootstrapped = false;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => poll());
    poll();
  }

  Future<void> poll() async {
    final result = await _api.fetchSensors();
    if (!result.ok || result.data == null) return;
    final data = result.data!;
    final status = data['mine_status']?.toString() ?? '';
    final detected = isMineDetectedStatus(
      status,
      mineDetectedFlag: data['mine_detected'] == true,
    );

    mineStatus = status;
    mineDetected = detected;

    // Premier poll : synchronise l'état sans bip (mine déjà présente au boot)
    if (!_bootstrapped) {
      _bootstrapped = true;
      _wasDetected = detected;
      notifyListeners();
      return;
    }

    if (detected && !_wasDetected) {
      await _triggerAlert();
    }
    _wasDetected = detected;
    notifyListeners();
  }

  Future<void> _triggerAlert() async {
    try {
      await HapticFeedback.heavyImpact();
      await _player.stop();
      await _player.play(AssetSource('sounds/mine_alert.wav'));
    } catch (e) {
      debugPrint('Mine alert sound error: $e');
      // Pas de SystemSound au catch : évite un bip parasite si l'asset échoue
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
