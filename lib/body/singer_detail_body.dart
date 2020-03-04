import 'package:flutter/material.dart';
import 'package:flutter_music/bean/singer_list.dart';
import 'package:flutter_music/bean/singer_song.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/util.dart';

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

  SingerSong _singerSong;

  var tabs = [
    Tag(id: 1, name: '歌曲'),
    Tag(id: 2, name: '专辑'),
    Tag(id: 3, name: 'MV'),
  ];

  _onScroll(offset) {
    var opacity = offset / 220.0;

    if (opacity > 1) opacity = 1.0;
    if (opacity < 0) opacity = 0.0;
    setState(() {
      hideTab = offset > 215 ? false : true;
      showTitle = opacity;
    });
  }

  @override
  void initState() {
    _futureBuilderFuture = HttpRequest.getMusicHome();
    _controller = TabController(length: tabs.length, vsync: ScrollableState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
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
                              print('waiting');
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.done:
                              print('done');
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              switch(v.id){
                                case 1:
                                  _singerSong = SingerSong.fromJson(snapshot.data);
                                  print(_singerSong.singerSongList.data.singerMid);
                                  break;
                                case 2:
                                  break;
                                case 3:
                                  break;
                              }
                              return _getMainWidget(context);
                            default:
                              return null;
                          }
                        },
                        future: _requestApi(widget.singerMid, v.id));
                  }).toList(),
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Opacity(
                opacity: showTitle,
                child: AppBar(
                  title: Text(widget.singerName),
                  elevation: 0,
                ),
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
    );
  }

  _getMainWidget(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) => ListTile(
          title: Text(_singerSong.singerSongList.data.songList[index].songInfo.name),
        ),
      ),
    );
  }

  _requestApi(String singerMid,int type){
    return Future((){
      switch(type){
        case 1:
          HttpRequest.getSingerSong(singerMid);
          break;
        case 2:
          HttpRequest.getSingerAlbum(singerMid);
          break;
        case 3:
          HttpRequest.getSingerMv(singerMid);
          break;
      }
    });
  }
}
