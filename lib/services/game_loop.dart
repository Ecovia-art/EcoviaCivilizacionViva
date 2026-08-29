import 'dart:async';
import '../models/game_state.dart';

class GameLoop {
  final GameState gameState;
  Timer? _timer;

  GameLoop(this.gameState);

  void start() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      gameState.actualizarCiclo(0.1);
    });
  }

  void stop() => _timer?.cancel();
}