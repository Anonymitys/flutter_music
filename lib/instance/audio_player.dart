import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_music/data/global_variable.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/event_bus_util.dart';

//var audioPlayer = AudioPlayer();

var audioPlayerUtil = AudioPlayerUtil();

class AudioPlayerUtil {
  AudioPlayer _audioPlayer;

  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription _playerCompleteSubscription;

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

    _playerCompleteSubscription =
        audioPlayerUtil.getAudioPlayer().onPlayerCompletion.listen((event) {
          _playNext();
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

  Future<int> _playNext() async {
    String url = "";
    globalCurrentIndex++;
    print(globalCurrentIndex);
    if (globalCurrentIndex >= songDetails.length) {
      globalCurrentIndex = 0;
    }
    await HttpRequest.getvKey(songDetails[globalCurrentIndex].getSongMid())
        .then((value) {
      url = 'http://ws.stream.qqmusic.qq.com/$value';
    });
    final result = await audioPlayerUtil.getAudioPlayer().play(url);
    eventBus.fire(
        CurrentPlayAlbumEvent(songDetails[globalCurrentIndex].getAlbumMid()));
    if (result == 1) _audioPlayerState = AudioPlayerState.PLAYING;
    audioPlayerUtil.getAudioPlayer().setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  void dispose() {
    _audioPlayer.stop();
  }
}
