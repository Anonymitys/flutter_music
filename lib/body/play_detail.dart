import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_music/bean/album_entity.dart';
import 'package:flutter_music/bean/cd_list.dart';
import 'package:flutter_music/data/global_variable.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/Global.dart';
import 'package:flutter_music/utils/util.dart';
import 'package:flutter_music/widget.dart';

class PlayDetailBody extends StatefulWidget {

  PlayDetailBody();

  @override
  State createState() => _PlayDetailState();
}

class _PlayDetailState extends State<PlayDetailBody> {
  String url;
  var _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = HttpRequest.getvKey(songDetails[globalCurrentIndex].getSongMid());
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
            getSongPic(songDetails[globalCurrentIndex].getAlbumMid()),
            fit: BoxFit.cover,
          ),
        ),
        PlayerWidget(url: url),
      ],
    );
  }
}
