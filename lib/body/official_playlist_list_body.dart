import 'package:flutter_music/bean/official_play_list.dart';
import 'package:flutter_music/body/recomend.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/utils/util.dart';

class OfficialPlaylistPage extends StatefulWidget {
  @override
  State createState() => _OfficialPlaylistState();
}

class _OfficialPlaylistState extends State<OfficialPlaylistPage> {
  var _futureBuilderFuture;
  double top = 0;
  OfficialPlayLists _officialPlaylists;

  @override
  void initState() {
    _futureBuilderFuture = HttpRequest.getOfficialPlaylist();
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
                _officialPlaylists = OfficialPlayLists.fromJson(snapshot.data);
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
                    'QQ音乐官方歌单',
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
               Navigator.of(context).push(MaterialPageRoute(builder: (_)=>HomePage(tid)));
              },
            ),
            childCount: _officialPlaylists.officialPlaylist.data.vPlaylist.length,
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
        callback(_officialPlaylists.officialPlaylist.data.vPlaylist[index].tid);
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
                  child: Image.network(_officialPlaylists
                      .officialPlaylist.data.vPlaylist[index].coverUrlBig),
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
                          listenNum(_officialPlaylists.officialPlaylist.data
                              .vPlaylist[index].accessNum),
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
              _officialPlaylists.officialPlaylist.data.vPlaylist[index].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'QQ音乐官方歌单',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
