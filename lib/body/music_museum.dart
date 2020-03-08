import 'package:flutter/material.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:flutter_music/bean/album_entity.dart';
import 'package:flutter_music/bean/group_top_list.dart';
import 'package:flutter_music/bean/home.dart';
import 'package:flutter_music/bean/mv_detail.dart';
import 'package:flutter_music/body/album_detail.dart';
import 'package:flutter_music/body/recomend.dart';
import 'package:flutter_music/body/top_list_detail.dart';
import 'package:flutter_music/body/toplist.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/util.dart';
import 'package:flutter_music/base_widget.dart';

import '../app_routes.dart';

class MusicMuseum extends StatefulWidget {
  @override
  State createState() => _MusicMuseumState();
}

class _MusicMuseumState extends State<MusicMuseum> {
  var _futureBuilderFuture;
  MusicHome _musicHome;
  MV _mv;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = HttpRequest.getMusicHome();
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
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  _musicHome = MusicHome.fromJson(snapshot.data[0]);
                  _mv = MV.fromJson(snapshot.data[1]);
                  return _getMusicHomeBody(context);
                default:
                  return null;
              }
            },
            future: _futureBuilderFuture));
  }

  Widget _getMusicHomeBody(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: _titleSearch(),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 0, right: 0),
        child: CustomScrollView(
          slivers: <Widget>[
            _banner(),
            _content(),
            title('官方歌单', '更多', 10, () {
              print('hello world');
            }),
            SliverToBoxAdapter(
              child: Container(
                height: 320,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) =>
                        _playlistItem(index, 1, (index) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(_musicHome
                                      .officialPlaylist
                                      .data
                                      .vPlaylist[index]
                                      .tid)));
                        })),
              ),
            ),
            title('推荐歌单', '更多', 10, () {
              print('hello world');
            }),
            SliverToBoxAdapter(
              child: Container(
                height: 370,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) =>
                        _playlistItem(index, 0, (index) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(_musicHome
                                      .recomPlaylist
                                      .data
                                      .vHot[index]
                                      .contentId)));
                        })),
              ),
            ),
            title('新歌速递', '更多', 10, () {
              print('hello world');
            }),
            SliverToBoxAdapter(
              child: Container(
                height: 380,
                child: PageView.custom(
                    childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) => _sonlistItem(index, (songMid) {
                    print(songMid);
                  }),
                  childCount: 3,
                )),
              ),
            ),
            title('最新专辑', '更多', 10, () {
              print('hello world');
            }),
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      _gridAlbumItem(index, (albumMid) {
                    // print(albumMid);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AlbumDetailBody(albumMid)));
                  }),
                  itemCount: 9,
                ),
              ),
            ),
            title('精选视频', '更多', 10, () {
              print('hello world');
            }),
            SliverToBoxAdapter(
              child: Container(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => _mvItem(
                    index,
                    (vid) {
                      print(vid);
                    },
                  ),
                  itemCount: 6,
                ),
              ),
            ),
            title('热歌风向标', '更多', 10, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => TopListBody(
                        groupTop: _musicHome.groupTopList.data.groupTop,
                      )));
            }),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                child: PageView.custom(
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => _topListItem(index, (topId) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => TopListDetailPage(topId)));
                    }),
                    childCount: 4,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 40,
              ),
            )
          ],
        ),
      ));

  Widget _titleSearch() => GestureDetector(
        onTap: () {
          print('hello world');
        },
        child: Container(
          width: 330,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.grey,
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
              Text(
                '经典永流传',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _banner() => SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 20),
          child: BannerSwiper(
            width: 345,
            height: 862,
            length: _musicHome.focus.data.content.length,
            spaceMode: false,
            getwidget: (index) => GestureDetector(
              onTap: () {
                print(index % _musicHome.focus.data.content.length);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _musicHome
                      .focus
                      .data
                      .content[index % _musicHome.focus.data.content.length]
                      .picInfo
                      .url,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _content() => SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _contentItem('images/singer.png', '歌手', () {
              Navigator.of(context).pushNamed(Routes.SINGER_LIST);
            }),
            _contentItem('images/rank.png', '排行', () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TopListBody(
                    groupTop: _musicHome.groupTopList.data.groupTop,
                  ),
                ),
              );
            }),
            _contentItem('images/sort_play_list.png', '分类歌单', () {}),
          ],
        ),
      );

  _contentItem(String imagePath, String title, VoidCallback callback) =>
      GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          width: 80,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imagePath,
                width: 20,
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Text(title),
            ],
          ),
        ),
      );

  Widget _gridAlbumItem(int index, void Function(String albumMid) callback) {
    String singerStr = '';
    _musicHome.newAlbumList.data.albums[index].singers.forEach((singer) {
      singerStr = '$singerStr${singer.singerName}/';
    });
    singerStr = singerStr.substring(0, singerStr.length - 1);
    return GestureDetector(
      onTap: () {
        callback(_musicHome.newAlbumList.data.albums[index].mid);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                getSongPic(_musicHome.newAlbumList.data.albums[index].mid),
                width: 115,
                height: 115,
                fit: BoxFit.cover,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            SizedBox(
              width: 115,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _musicHome.newAlbumList.data.albums[index].name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Text(singerStr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridPlaylistItem(int index, int type, void Function(int i) callback) {
    String url;
    int num;
    String title;
    if (type == 1) {
      url = _musicHome.officialPlaylist.data.vPlaylist[index].coverUrlBig;
      num = _musicHome.officialPlaylist.data.vPlaylist[index].accessNum;
      title = _musicHome.officialPlaylist.data.vPlaylist[index].title;
    } else if (type == 0) {
      url = _musicHome.recomPlaylist.data.vHot[index].cover;
      num = _musicHome.recomPlaylist.data.vHot[index].listenNum;
      title = _musicHome.recomPlaylist.data.vHot[index].title;
    }
    return GestureDetector(
      onTap: () {
        callback(index);
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    url,
                    width: 115,
                    height: 115,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.headset_mic,
                        color: Colors.white,
                        size: 14,
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        listenNum(num),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            SizedBox(
              width: 115,
              child: Text(
                title,
                maxLines: type == 1 ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playlistItem(int index, int type, void Function(int index) callback) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Column(
        children: <Widget>[
          _gridPlaylistItem(index, type, callback),
          _gridPlaylistItem(index + 6, type, callback),
        ],
      ),
    );
  }

  Widget _sonlistItem(int index, void Function(String songMid) callback) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, i) => ListTile(
          onTap: () {
            callback(_musicHome.newSongList.data.songlist[i + 5 * index].mid);
            // callback(i + 5 * index);
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              getSongPic(_musicHome
                  .newSongList.data.songlist[i + 5 * index].album.pMid),
              width: 55,
              height: 55,
            ),
          ),
          title: Text(_musicHome.newSongList.data.songlist[i + 5 * index].name),
          subtitle: Text(
            subtitleFormat(_musicHome.newSongList.data.songlist[i + 5 * index]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Offstage(
            offstage: _musicHome
                .newSongList.data.songlist[i + 5 * index].mv.vid.isEmpty,
            child: Icon(Icons.video_library),
          )),
    );
  }

  _topListItem(int index, void Function(int topId) callback) {
    return GestureDetector(
      onTap: () {
        callback(_musicHome.groupTopList.data.groupTop[0].toplist[index].topId);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  _musicHome.groupTopList.data.groupTop[0].toplist[index].title,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, i) => _songItem(_musicHome
                  .groupTopList.data.groupTop[0].toplist[index].song[i]),
            )
          ],
        ),
      ),
    );
  }

  _songItem(Song song) {
    return Container(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              getSongPic(song.albumMid),
              width: 60,
              height: 60,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 15)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  song.title,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Text(
                  song.singerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _mvItem(int index, void Function(String vid) callback) {
    return GestureDetector(
      onTap: () {
        callback(_mv.data.mvlist[index].vid);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    _mv.data.mvlist[index].picurl,
                    width: 320,
                    height: 180,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.missed_video_call,
                        color: Colors.white,
                      ),
                      Text(
                        listenNum(_mv.data.mvlist[index].listennum),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _mv.data.mvlist[index].mvtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    _mv.data.mvlist[index].singerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
