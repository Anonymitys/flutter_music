import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

//var audioPlayer = AudioPlayer();

var audioPlayerUtil = AudioPlayerUtil();

class AudioPlayerUtil {
  AudioPlayer _audioPlayer;

  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  Duration _duration;
  Duration _position;
  AudioPlayerState _audioPlayerState = AudioPlayerState.STOPPED;

  void init() {
    if (_audioPlayer == null) {
      _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    }

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      print('duration:$duration');
    });

    _positionSubscription =
        audioPlayerUtil.getAudioPlayer().onAudioPositionChanged.listen((p) {
      _position = p;
    });

    _playerErrorSubscription =
        audioPlayerUtil.getAudioPlayer().onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      _duration = Duration(seconds: 0);
      _position = Duration(seconds: 0);
    });

    audioPlayerUtil.getAudioPlayer().onPlayerStateChanged.listen((state) {
      _audioPlayerState = state;
    });
  }

  AudioPlayer getAudioPlayer() {
    return _audioPlayer;
  }

  Duration getDuration() {
    return _duration;
  }

  Duration getPosition() {
    return _position;
  }

  AudioPlayerState getPlayState() {
    return _audioPlayerState;
  }

  void dispose() {
    _audioPlayer.stop();
  }
}


