import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_music/bean/album_entity.dart';
import 'package:flutter_music/bean/cd_list.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/Global.dart';
import 'package:flutter_music/utils/util.dart';
import 'package:flutter_music/widget.dart';

class PlayDetailBody extends StatefulWidget {
  bool isPlayList;

  List<Songlist> cdlist;
  List<SongList> songlists;
  int currentIndex;

  PlayDetailBody(this.isPlayList, this.currentIndex,
      {this.cdlist, this.songlists});

  @override
  State createState() => _PlayDetailState();
}

class _PlayDetailState extends State<PlayDetailBody> {
  String url;
  var _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = HttpRequest.getvKey(
        widget.isPlayList ? widget.cdlist[widget.currentIndex].songmid : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                print('还没有开始网络请求');
                return Text('还没有开始网络请求');
              case ConnectionState.active:
                print('active');
                return Text('ConnectionState.active');
              case ConnectionState.waiting:
                print('waiting');
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                print('done');
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                url = 'http://ws.stream.qqmusic.qq.com/${snapshot.data}';
                return _getMainWidget(context);
              default:
                return null;
            }
          },
          future: _futureBuilderFuture),
    );
  }

  _getMainWidget(context) {
    print(url);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300,
          height: 300,
          child: Image.network(
            getSongPic(widget.cdlist[widget.currentIndex].albummid),
            fit: BoxFit.cover,
          ),
        ),
        PlayerWidget(url: url),
      ],
    );
  }

  @override
  void deactivate() {
    Global.getInstance().updateGlobalWidget(false,
        index: widget.currentIndex,
        songlist: widget.songlists,
        cdlist: widget.cdlist,
        isPlaylist: widget.isPlayList);
    super.deactivate();
  }
}
