import 'package:flutter/material.dart';
import 'package:flutter_music/app_routes.dart';
import 'package:flutter_music/bean/toplist_detail.dart';
import 'package:flutter_music/data/global_variable.dart';
import 'package:flutter_music/utils/event_bus_util.dart';
import 'package:palette_generator/palette_generator.dart';

import '../network/network_util.dart';
import '../utils/util.dart';

class TopListDetailPage extends StatefulWidget {
  final topId;

  TopListDetailPage(this.topId);

  @override
  State createState() => _TopListDetailstate();
}

class _TopListDetailstate extends State<TopListDetailPage> {
  var _futureBuilderFuture;
  TopListDetail _topListDetail;
  var top = 0.0;
  Color pickColor;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _requestApi(widget.topId);
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
                return _getMainWidget(context);
              default:
                return null;
            }
          },
          future: _futureBuilderFuture),
    );
  }

  _getMainWidget(context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 280,
          backgroundColor: pickColor,
          textTheme: TextTheme(body1: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              top = constraints.biggest.height;
              print(top);
              return FlexibleSpaceBar(
                centerTitle: true,
                title: Opacity(
                  opacity: top <= 100.0 ? 1.0 : 0.0,
                  child: Text(
                    _topListDetail.detail.data.dataSub.titleDetail,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.network(
                      _topListDetail.detail.data.dataSub.headPicUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 15,
                      child: Row(
                        children: <Widget>[
                          Text(
                            '${_topListDetail.detail.data.dataSub.updateTime}更新',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          elevation: 0,
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _toplistItem(index),
            childCount: _topListDetail.detail.data.songInfoList.length,
          ),
        ),
      ],
    );
  }

  _toplistItem(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
       // callback(_topListDetail.detail.data.songInfoList[index].mid);
        songDetails =  _topListDetail.detail.data.songInfoList;
        globalCurrentIndex = index;
        eventBus.fire(CurrentPlayAlbumEvent(songDetails[globalCurrentIndex].getAlbumMid()));
        Navigator.of(context).pushNamed(Routes.PLAY_DETAIL);
      },
      child: Container(
        height: 70,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('${index + 1}'),
            Padding(padding: EdgeInsets.only(left: 20)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _topListDetail.detail.data.songInfoList[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    subtitleFormat(
                      _topListDetail.detail.data.songInfoList[index],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 10)),
            Offstage(
              offstage:
                  _topListDetail.detail.data.songInfoList[index].mv.vid.isEmpty,
              child: IconButton(
                icon: Icon(Icons.video_library),
                onPressed: () {
                  print(_topListDetail.detail.data.songInfoList[index].mv.vid);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _requestApi(int topId) {
    return Future(() => HttpRequest.getTopListdDetail(topId).then((value) {
          _topListDetail = TopListDetail.fromJson(value);
          return PaletteGenerator.fromImageProvider(
              NetworkImage(_topListDetail.detail.data.dataSub.headPicUrl));
        }).then((paletteGenerator) {
          if (paletteGenerator != null && paletteGenerator.colors.isNotEmpty)
            pickColor = paletteGenerator.colors.toList()[0].withOpacity(1);
        }));
  }
}
