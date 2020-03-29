import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_music/app_routes.dart';
import 'package:flutter_music/bean/singer_album.dart';
import 'package:flutter_music/bean/singer_list.dart';
import 'package:flutter_music/bean/singer_mv.dart';
import 'package:flutter_music/bean/singer_song.dart';
import 'package:flutter_music/body/album_detail.dart';
import 'package:flutter_music/body/play_mv.dart';
import 'package:flutter_music/data/global_variable.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/event_bus_util.dart';
import 'package:flutter_music/utils/util.dart';
import 'package:palette_generator/palette_generator.dart';

class SingerDetailBody extends StatefulWidget {
  final singerMid, singerName;

  SingerDetailBody(this.singerMid, this.singerName);

  @override
  State createState() => _SingerDetailState();
}

class _SingerDetailState extends State<SingerDetailBody> {
  var _futureBuilderFuture;
  var _controller;
  var showTitle = 0.0;
  var hideTab = true;
  int type = 1;
  bool isFirstClick = true;

  SingerSong _singerSong;
  SingerAlbum _singerAlbum;
  SingerMV _singerMV;
  double top;
  Color _pickColor = Colors.white;

  var tabs = [
    Tag(id: 1, name: '歌曲'),
    Tag(id: 2, name: '专辑'),
    Tag(id: 3, name: 'MV'),
  ];

  _onScroll(offset) {
    var opacity = offset / 200.0;

    if (opacity > 1) opacity = 1.0;
    if (opacity < 0) opacity = 0.0;
    setState(() {
      hideTab = offset > 200 ? false : true;
      showTitle = opacity;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = HttpRequest.getSingerDetail(widget.singerMid);
    _controller = TabController(length: tabs.length, vsync: ScrollableState());
    PaletteGenerator.fromImageProvider(
            NetworkImage(getSingerPic(widget.singerMid)))
        .then((paletteGenerator) {
      if (paletteGenerator != null && paletteGenerator.colors.isNotEmpty)
        _pickColor = paletteGenerator.colors.toList()[0].withOpacity(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    top = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: MediaQuery.removeViewPadding(
        removeTop: true,
        context: context,
        child: Stack(
          children: <Widget>[
            Container(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification &&
                      notification.depth == 0) {
                    print(notification.metrics.pixels);
                    _onScroll(notification.metrics.pixels);
                  }
                  return true;
                },
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) =>
                      <Widget>[
                    SliverToBoxAdapter(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                        child: Image.network(
                          getSingerPic(widget.singerMid),
                          fit: BoxFit.cover,
                          height: 300,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: TabBar(
                          controller: _controller,
                          labelPadding: EdgeInsets.only(top: 10, bottom: 5),
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: tabs.map((v) => Text(v.name)).toList(),
                        ),
                      ),
                    ),
                  ],
                  body: TabBarView(
                    controller: _controller,
                    children: tabs.map((v) {
                      return FutureBuilder(
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                print('还没有开始网络请求');
                                return Text('还没有开始网络请求');
                              case ConnectionState.active:
                                print('active');
                                return Text('ConnectionState.active');
                              case ConnectionState.waiting:
                                print('waiting${v.id}');
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.done:
                                print('done${v.id}');
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                                switch (v.id) {
                                  case 1:
                                    _singerSong =
                                        SingerSong.fromJson(snapshot.data[0]);
                                    return _getMainSong(context);
                                    break;
                                  case 2:
                                    _singerAlbum =
                                        SingerAlbum.fromJson(snapshot.data[1]);
                                    return _getMainAlbum(context);
                                    break;
                                  case 3:
                                    _singerMV =
                                        SingerMV.fromJson(snapshot.data[2]);
                                    return _getMainMV(context);
                                    break;
                                  default:
                                    return Container();
                                }
                                break;
                              default:
                                return null;
                            }
                          },
                          future: _futureBuilderFuture);
                    }).toList(),
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: showTitle,
                      child: Container(
                          height: 56 + top,
                          padding: EdgeInsets.only(top: top),
                          color: _pickColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Text(
                                    widget.singerName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      height: 56 + top,
                      padding: EdgeInsets.only(top: top),
                      child: IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    )
                  ],
                ),
                Offstage(
                  offstage: hideTab,
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _controller,
                      labelPadding: EdgeInsets.only(top: 10, bottom: 5),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: tabs.map((v) => Text(v.name)).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getMainSong(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _singerSong.singerSongList.data.songList.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            _singerSong.singerSongList.data.songList[index].songInfo.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            subtitleFormat(
                _singerSong.singerSongList.data.songList[index].songInfo),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Offstage(
            offstage: _singerSong
                .singerSongList.data.songList[index].songInfo.mv.vid.isEmpty,
            child: IconButton(
                icon: Icon(Icons.video_library),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PlayMVBody(_singerSong
                      .singerSongList.data.songList[index].songInfo.mv.vid)));
                }),
          ),
          onTap: () {
            // print(_singerSong.singerSongList.data.songList[index].songInfo.mid);
            if (isFirstClick) {
              isFirstClick = false;
              songDetails.clear();
              _singerSong.singerSongList.data.songList.forEach((v) {
                songDetails.add(v.songInfo);
              });
            }
            globalCurrentIndex = index;
            eventBus.fire(CurrentPlayAlbumEvent(_singerSong.singerSongList.data.songList[index].songInfo.album.mid));
            Navigator.of(context).pushNamed(Routes.PLAY_DETAIL);
          },
        ),
      ),
    );
  }

  _getMainAlbum(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _singerAlbum.getAlbumList.data.albumList.length,
        itemBuilder: (context, index) => ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              getSongPic(
                _singerAlbum.getAlbumList.data.albumList[index].albumMid,
              ),
            ),
          ),
          title: Text(
            _singerAlbum.getAlbumList.data.albumList[index].albumName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${_singerAlbum.getAlbumList.data.albumList[index].publishDate}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            // print(_singerAlbum.getAlbumList.data.albumList[index].albumMid);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AlbumDetailBody(
                    _singerAlbum.getAlbumList.data.albumList[index].albumMid)));
          },
        ),
      ),
    );
  }

  _getMainMV(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: GridView.builder(
            itemCount: _singerMV.data.list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 10,
                childAspectRatio: 6 / 5),
            itemBuilder: (context, index) => _mvItem(index)));
  }

  _mvItem(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PlayMVBody(_singerMV.data.list[index].vid)));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    _singerMV.data.list[index].pic,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Text(
              _singerMV.data.list[index].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
