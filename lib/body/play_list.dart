import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_music/bean/sort_play_list.dart';
import 'package:flutter_music/body/recomend.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/util.dart';

class PlayListBody extends StatefulWidget {
  final int categoryId, sortId;
  final String categoryName;

  PlayListBody(this.categoryId, this.categoryName, this.sortId);

  @override
  State createState() => _PlaylistStates();
}

class _PlaylistStates extends State<PlayListBody> {
  var _futureBuilderFuture;
  SortPlayList _sortPlayList;
  double top = 0;

  @override
  void initState() {
    _futureBuilderFuture =
        HttpRequest.getPlaylist(widget.categoryId, widget.sortId);
    super.initState();
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
                _sortPlayList = SortPlayList.fromJson(snapshot.data);
                print(_sortPlayList.data.list[0].dissname);
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
          expandedHeight: 200,
          backgroundColor: Colors.grey,
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
                    widget.categoryName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                background: Image.asset(
                  'images/bg_official_playlist.jpg',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          elevation: 0,
          pinned: true,
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (_, index) => _areaGroup(
              index,
              (tid) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => HomePage(tid)));
              },
            ),
            childCount: _sortPlayList.data.list.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 5 / 6),
        ),
      ],
    );
  }

  _areaGroup(int index, void Function(int disstid) callback) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        callback(int.parse(_sortPlayList.data.list[index].dissid));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(_sortPlayList.data.list[index].imgurl),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8, bottom: 5, right: 5),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.headset_mic,
                        color: Colors.white,
                        size: 14,
                      ),
                      Expanded(
                        child: Text(
                          listenNum(_sortPlayList.data.list[index].listennum),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Text(
              _sortPlayList.data.list[index].dissname,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
