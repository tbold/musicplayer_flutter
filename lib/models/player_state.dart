import 'package:flutter/material.dart';

enum PlayState { isPlaying, isStopped, isPaused }

abstract class PlayerState {
  abstract final PlayerState nextState;
  abstract final IconData icon;
}

class PausedState implements PlayerState {
  PlayState currentState = PlayState.isPaused;

  PausedState() : super();

  @override
  PlayerState get nextState => PlayingState();

  @override
  IconData get icon => Icons.pause;
}

class StoppedState implements PlayerState {
  PlayState currentState = PlayState.isStopped;

  StoppedState() : super();

  @override
  PlayerState get nextState => PlayingState();
  @override
  IconData get icon => Icons.stop;
}

class PlayingState implements PlayerState {
  PlayState currentState = PlayState.isPaused;

  PlayingState() : super();

  PlayerState get secondaryState => StoppedState();
  @override
  PlayerState get nextState => PausedState();
  @override
  IconData get icon => Icons.play_arrow;
}
