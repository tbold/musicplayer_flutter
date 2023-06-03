import 'package:flutter/material.dart';

enum PlayState { isPlaying, isStopped, isPaused }

abstract class PlayerWidgetState {
  abstract final PlayerWidgetState nextState;
  abstract final IconData icon;
}

class PausedState implements PlayerWidgetState {
  PlayState currentState = PlayState.isPaused;

  PausedState() : super();

  @override
  PlayerWidgetState get nextState => PlayingState();

  @override
  IconData get icon => Icons.pause;
}

class StoppedState implements PlayerWidgetState {
  PlayState currentState = PlayState.isStopped;

  StoppedState() : super();

  @override
  PlayerWidgetState get nextState => PlayingState();
  @override
  IconData get icon => Icons.stop;
}

class PlayingState implements PlayerWidgetState {
  PlayState currentState = PlayState.isPaused;

  PlayingState() : super();

  PlayerWidgetState get secondaryState => StoppedState();
  @override
  PlayerWidgetState get nextState => PausedState();
  @override
  IconData get icon => Icons.play_arrow;
}
