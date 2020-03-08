import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_music/bean/cd_list.dart';
import 'package:flutter_music/bean/tag_entity.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:palette_generator/palette_generator.dart';

Cdlist _cdlist;
Color pickColor;
bool isOfficialList = false;
bool isAlbum = false;
double height, screenWidth;
double top;

_requestAPI(int disstid) =>
    Future(() => HttpRequest.getPlaylistDetail(disstid)).then((value) {
      _cdlist = PlayList.fromJson(value).cdlist[0];
      if (_cdlist.nickname == 'QQ音乐官方歌单') {
        isOfficialList = true;
      } else {
        isOfficialList = false;
      }
      return PaletteGenerator.fromImageProvider(NetworkImage(_cdlist.logo));
    }).then((paletteGenerator) {
      if (paletteGenerator != null && paletteGenerator.colors.isNotEmpty) {
        pickColor = paletteGenerator.colors.toList()[0].withOpacity(1);
      }
    });

_subtitleFormat(Songlist songlist) {
  String str = '';
  songlist.singer.forEach((singer) {
    str = '$str${singer.singerName}/';
  });
  return '${str.substring(0, str.length - 1)}·${songlist.albumname}';
}

_playlist(int index) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: (){
      print(_cdlist.songlist[index].songmid);
    },
    child: Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Text('${index + 1}'),
          Padding(padding: EdgeInsets.only(left: 20)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _cdlist.songlist[index].songname,
                  style: TextStyle(fontSize: 16),
                ),
                Padding(padding: EdgeInsets.only(top: 3)),
                Text(
                  _subtitleFormat(_cdlist.songlist[index]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Offstage(
            offstage: _cdlist.songlist[index].vid.isEmpty,
            child: IconButton(
                icon: Icon(Icons.video_library),
                onPressed: () {
                  print(_cdlist.songlist[index].vid);
                }),
          )
        ],
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  final int disstid;

  HomePage(this.disstid);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _futureBuilderFuture;
  var _title = '歌单';
  double opacity = 0;
  bool showPlayAll = false;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _requestAPI(widget.disstid);
  }

  _onScroll(offset) {
    showPlayAll = offset >= 200 ? true : false;
    double alpha = offset / 200;
    print(offset);
    _title = (alpha > 0.5) ? _cdlist.dissname : '歌单';
    if (alpha > 1) alpha = 1;
    if (alpha < 0) alpha = 0;
    setState(() {
      opacity = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    top = MediaQuery.of(context).padding.top;
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
                return isOfficialList
                    ? OfficialPlayListWidget()
                    : _getMainWidget(context);
              default:
                return null;
            }
          },
          future: _futureBuilderFuture),
    );

  }

  Widget _getMainWidget(BuildContext context) {
    return MediaQuery.removeViewPadding(
      removeTop: true,
      context: context,
      child: Stack(
        children: <Widget>[
          Container(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification &&
                    notification.depth == 0) {
                  _onScroll(notification.metrics.pixels);
                }
                return true;
              },
              child: NestedScrollView(
                headerSliverBuilder: (context, index) => <Widget>[
                  SliverToBoxAdapter(
                    child: _playlistHeader(context),
                  ),
                  SliverToBoxAdapter(
                    child: _playAll(context),
                  ),
                ],
                body: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (_, index) => _playlist(index),
                  itemCount: _cdlist.songlist.length,
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 56+top,
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: opacity,
                      child: Container(
                        color: pickColor,
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(left: 10, top: top),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_left,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          Expanded(
                            child: Center(
                              child: Text(
                                _title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: !showPlayAll,
                child: _playAll(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _playlistHeader(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            color: pickColor,
            padding: EdgeInsets.only(top: 50),
            height: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  child: Image.network(
                    _cdlist.logo,
                    width: 120,
                    height: 120,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                Padding(padding: EdgeInsets.only(left: 25)),
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _cdlist.dissname,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                _cdlist.headurl,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Flexible(
                            child: Text(
                              _cdlist.nickname,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: _listTag(_cdlist.tags),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _playAll(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: 45,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.play_arrow),
          Padding(padding: EdgeInsets.only(right: 10)),
          Text(
            '播放全部',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text('(共${_cdlist.totalSongNum}首)'),
        ],
      ),
    );
  }

  _listTag(List<Tags> tags) {
    List<Widget> widgets = List<Widget>();

    tags.forEach((v) {
      widgets.add(_tagWidget(v.name));
    });
    return widgets;
  }

  _tagWidget(String text) => Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
}

class OfficialPlayListWidget extends StatefulWidget {
  @override
  State createState() => _OfficiallistStates();
}

class _OfficiallistStates extends State<OfficialPlayListWidget> {
  double opacity = 0.0;
  bool showPlayAll = false;

  @override
  void initState() {
    super.initState();
  }

  _onScroll(offset) {
    showPlayAll = offset > 265 ? true : false;
    double alpha = offset / 200;
    print(offset);
    if (alpha > 1) alpha = 1;
    if (alpha < 0) alpha = 0;
    setState(() {
      opacity = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Stack(
          children: <Widget>[
            Container(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification &&
                      notification.depth == 0) {
                    _onScroll(notification.metrics.pixels);
                  }
                  return true;
                },
                child: NestedScrollView(
                  headerSliverBuilder: (context, index) => <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.topCenter,
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(_cdlist.logo),
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth - 20,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            transform: Matrix4.translationValues(0, -10, 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.network(
                                      _cdlist.headurl,
                                      width: 20,
                                      height: 20,
                                    ),
                                    Text(_cdlist.nickname),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    _cdlist.desc,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _playAll(context),
                    ),
                  ],
                  body: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (_, index) => _playlist(index),
                    itemCount: _cdlist.songlist.length,
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: opacity,
                      child: Container(
                          height: 56 + top,
                          padding: EdgeInsets.only(top: top),
                          color: pickColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Text(
                                    _cdlist.dissname,
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
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Widget _playAll(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: 45,
      child: Row(
        children: <Widget>[
          Icon(Icons.play_arrow),
          Padding(padding: EdgeInsets.only(right: 10)),
          Text(
            '播放全部',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text('(共${_cdlist.totalSongNum}首)'),
        ],
      ),
    );
  }
}
