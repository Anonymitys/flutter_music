import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/bean/song_detail.dart';
import 'package:flutter_music/data/global_variable.dart';
import 'package:flutter_music/instance/audio_player.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/event_bus_util.dart';
import 'package:flutter_music/utils/util.dart';

class PlayDetailBody extends StatefulWidget {
  final bool autoPlay;

  PlayDetailBody({this.autoPlay = true});

  @override
  State createState() => _PlayDetailState();
}

class _PlayDetailState extends State<PlayDetailBody> {
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getMainWidget(context),
    );
  }

  _getMainWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300,
          height: 300,
          child: StreamBuilder<CurrentPlayAlbumEvent>(
            stream: eventBus.on<CurrentPlayAlbumEvent>(),
            initialData: CurrentPlayAlbumEvent(
                songDetails[globalCurrentIndex].getAlbumMid()),
            builder: (context, snapshot) => Image.network(
              getSongPic(snapshot.data.url),
            ),
          ),
        ),
        PlayerWidget(widget.autoPlay),
      ],
    );
  }
}

enum PlayerState { stopped, playing, paused }

class PlayerWidget extends StatefulWidget {
  final bool autoPlay;

  PlayerWidget(this.autoPlay);

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  PlayerMode mode = PlayerMode.MEDIA_PLAYER;

 // AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  String get _durationText => _duration?.toString()?.split('.')?.first?.substring(2) ?? '';

  String get _positionText => _position?.toString()?.split('.')?.first?.substring(2) ?? '';

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    if (widget.autoPlay) {
      _play();
    }
  }

  @override
  void dispose() {
//    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          songDetails[globalCurrentIndex].getSongName(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
        Text(_subtitleFormat(songDetails[globalCurrentIndex])),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: Key('play_button'),
              onPressed: () {
                _playPrevious();
              },
              iconSize: 64.0,
              icon: Icon(Icons.fast_rewind),
            ),
            IconButton(
              key: Key('pause_button'),
              onPressed: () {
                _audioPlayerState == AudioPlayerState.PLAYING
                    ? _pause()
                    : audioPlayerUtil.getAudioPlayer().resume();
              },
              iconSize: 64.0,
              icon: _audioPlayerState == AudioPlayerState.PLAYING
                  ? Icon(Icons.pause)
                  : Icon(Icons.play_arrow),
            ),
            IconButton(
              key: Key('stop_button'),
              onPressed: () {
                _playNext();
              },
              iconSize: 64.0,
              icon: Icon(Icons.fast_forward),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Slider(
                    onChanged: (v) {
                      final position = v * _duration.inMilliseconds;
                      audioPlayerUtil.getAudioPlayer()
                          .seek(Duration(milliseconds: position.round()));
                    },
                    value: (_position != null &&
                            _duration != null &&
                            _position.inMilliseconds > 0 &&
                            _position.inMilliseconds < _duration.inMilliseconds)
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0.0,
                  ),
                ],
              ),
            ),
            Text(
              _position != null
                  ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                  : _duration != null ? _durationText : '',
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
        Text('State: $_audioPlayerState')
      ],
    );
  }

  Future<int> _play() async {
    if (url == null) {
      await HttpRequest.getvKey(songDetails[globalCurrentIndex].getSongMid())
          .then((value) {
        url = 'http://ws.stream.qqmusic.qq.com/$value';
      });
    }
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await audioPlayerUtil.getAudioPlayer().play(url, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    audioPlayerUtil.getAudioPlayer().setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _playNext() async {
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
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    audioPlayerUtil.getAudioPlayer().setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _playPrevious() async {
    globalCurrentIndex--;
    if (globalCurrentIndex < 0) {
      globalCurrentIndex = songDetails.length - 1;
    }
    await HttpRequest.getvKey(songDetails[globalCurrentIndex].getSongMid())
        .then((value) {
      url = 'http://ws.stream.qqmusic.qq.com/$value';
    });
    final result = await audioPlayerUtil.getAudioPlayer().play(url);
    eventBus.fire(
        CurrentPlayAlbumEvent(songDetails[globalCurrentIndex].getAlbumMid()));
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    audioPlayerUtil.getAudioPlayer().setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await audioPlayerUtil.getAudioPlayer().pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await audioPlayerUtil.getAudioPlayer().stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    print("_onComplete");
    _playNext();
  }

  void _initAudioPlayer() {
   // _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = audioPlayerUtil.getAudioPlayer().onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
        print('duration:${duration}');
      });

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        audioPlayerUtil.getAudioPlayer().startHeadlessService();

        // set at least title to see the notification bar on ios.
        audioPlayerUtil.getAudioPlayer().setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30),
            // default is 30s
            backwardSkipInterval: const Duration(seconds: 30),
            // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _positionSubscription =
        audioPlayerUtil.getAudioPlayer().onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        audioPlayerUtil.getAudioPlayer().onPlayerCompletion.listen((event) {
      _onComplete();
    });

    _playerErrorSubscription = audioPlayerUtil.getAudioPlayer().onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    audioPlayerUtil.getAudioPlayer().onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    audioPlayerUtil.getAudioPlayer().onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });
  }
}

_subtitleFormat(SongDetail songDetail) {
  String str = '';
  songDetail.getSingers().forEach((singer) {
    str = '$str${singer.singerName}/';
  });
  return '${str.substring(0, str.length - 1)} · ${songDetail.getAlbumName()}';
}
