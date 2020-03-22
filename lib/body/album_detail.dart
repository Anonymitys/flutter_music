import 'package:flutter/material.dart';
import 'package:flutter_music/app_routes.dart';
import 'package:flutter_music/bean/album_entity.dart';
import 'package:flutter_music/bean/singer_entity.dart';
import 'package:flutter_music/body/singer_detail_body.dart';
import 'package:flutter_music/data/global_variable.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/base_widget.dart';
import 'package:flutter_music/utils/event_bus_util.dart';
import 'package:flutter_music/utils/util.dart';
import 'package:palette_generator/palette_generator.dart';

class AlbumDetailBody extends StatefulWidget {
  final String albumMid;

  AlbumDetailBody(this.albumMid);

  @override
  State createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetailBody> {
  var _futureBuilderFuture;
  AlbumDetail _albumDetail;
  Color pickColor;
  double top;
  var _title = '专辑';
  double opacity = 0;
  bool showPlayAll = false;
  bool isFirstClick =true;

  List<Singer> singers = List();

  @override
  void initState() {
    _futureBuilderFuture =
        HttpRequest.getAlbumDetail(widget.albumMid).then((value) {
          _albumDetail = AlbumDetail.fromJson(value);
          List<String> tmp = List();

          _albumDetail.albumSonglist.albumInfo.songList.forEach((v) {
            v.songInfo.singer.forEach((f) {
              if (!tmp.contains(f.singerMid)) {
                tmp.add(f.singerMid);
                singers.add(f);
              }
            });
          });
        });
    PaletteGenerator.fromImageProvider(
        NetworkImage(getSongPic(widget.albumMid)))
        .then((paletteGenerator) {
      if (paletteGenerator != null && paletteGenerator.colors.isNotEmpty)
        pickColor = paletteGenerator.colors.toList()[0].withOpacity(1);
    });
    super.initState();
  }

  _onScroll(offset) {
    showPlayAll = offset >= 200 ? true : false;
    double alpha = offset / 200;
    print(offset);
    _title = (alpha > 0.5)
        ? _albumDetail.albumSonglist.albumInfo.songList[0].songInfo.album.name
        : '专辑';
    if (alpha > 1) alpha = 1;
    if (alpha < 0) alpha = 0;
    setState(() {
      opacity = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    top = MediaQuery
        .of(context)
        .padding
        .top;
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
                return _getMainWidget(context);
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
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: _playlistHeader(context),
                  ),
                  SliverToBoxAdapter(
                    child: playAll(
                        context, _albumDetail.albumSonglist.albumInfo.totalNum),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => _playlist(index),
                      childCount:
                      _albumDetail.albumSonglist.albumInfo.songList.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 56 + top,
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
                child: playAll(
                    context, _albumDetail.albumSonglist.albumInfo.totalNum),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _playlist(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if(isFirstClick){
          isFirstClick = false;
          songDetails.clear();
          _albumDetail.albumSonglist.albumInfo.songList.forEach((v){
            songDetails.add(v.songInfo);
          });
        }
        globalCurrentIndex = index;
        eventBus.fire(CurrentPlayAlbumEvent(_albumDetail.albumSonglist.albumInfo.albumMid));
        Navigator.of(context).pushNamed(Routes.PLAY_DETAIL);

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
                    _albumDetail
                        .albumSonglist.albumInfo.songList[index].songInfo.title,
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    subtitleFormat(_albumDetail
                        .albumSonglist.albumInfo.songList[index].songInfo),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: _albumDetail.albumSonglist.albumInfo.songList[index]
                  .songInfo.mv.vid.isEmpty,
              child: IconButton(
                  icon: Icon(Icons.video_library),
                  onPressed: () {
                    print(_albumDetail.albumSonglist.albumInfo.songList[index]
                        .songInfo.mv.vid);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _playlistHeader(BuildContext context) =>
      Stack(
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
                    getSongPic(widget.albumMid),
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
                        _albumDetail.albumSonglist.albumInfo.songList[0]
                            .songInfo.album.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Row(
                        children: <Widget>[
                          Text(
                            '歌手:',
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          _formatSingers(context, singers),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  _formatSingers(BuildContext context, List<Singer> singers) {
    String str = '';
    singers.forEach((v) {
      str = '$str${v.singerName}/';
    });
    str = str.substring(0, str.length - 1);
    return Flexible(
      child: GestureDetector(
        onTap: () {
          if (singers.length == 1) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    SingerDetailBody(
                        singers[0].singerMid, singers[0].singerName)));
          } else {
            showModalBottomSheet(
                context: context,
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: singers
                            .map(
                              (v) =>
                              ListTile(
                                leading: Container(
                                  width: 30,
                                  height: 30,
                                  child: CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(getSingerPic(v.singerMid)),
                                  ),
                                ),
                                title: Text(v.singerName),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          SingerDetailBody(
                                              v.singerMid, v.singerName)));
                                },
                              ),
                        )
                            .toList(),
                      ),
                    ),
                  );
                });
          }
        },
        child: Text(
          str,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
