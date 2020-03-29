import 'package:flutter/material.dart';
import 'package:flutter_music/app_routes.dart';
import 'package:flutter_music/bean/new_album_list.dart';
import 'package:flutter_music/bean/new_song_list.dart';
import 'package:flutter_music/bean/singer_entity.dart';
import 'package:flutter_music/bean/singer_list.dart';
import 'package:flutter_music/body/album_detail.dart';
import 'package:flutter_music/body/play_mv.dart';
import 'package:flutter_music/data/global_variable.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/event_bus_util.dart';
import 'package:flutter_music/utils/util.dart';

class SongandAlbumBody extends StatefulWidget {
  bool isSong = true;

  SongandAlbumBody(this.isSong);

  @override
  State createState() => _SongAndAlbumState();
}

class _SongAndAlbumState extends State<SongandAlbumBody> {
  TabController _controller;
  NewSongList _songList;
  NewAlbumList _newAlbumList;

  var tabs = [
    Tag(type: 5, id: 1, name: '推荐', area: '内地'),
    Tag(type: 1, id: 2, name: '内地', area: '港台'),
    Tag(type: 6, id: 3, name: '港台', area: '欧美'),
    Tag(type: 2, id: 4, name: '欧美', area: '韩国'),
    Tag(type: 4, id: 5, name: '韩国', area: '日本'),
    Tag(type: 3, id: 6, name: '日本', area: '其他'),
  ];

  @override
  void initState() {
    _controller = TabController(length: tabs.length, vsync: ScrollableState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _titleWidget(),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          tabs: tabs
              .map((v) => widget.isSong ? Text(v.name) : Text(v.area))
              .toList(),
          controller: _controller,
          isScrollable: false,
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          labelPadding: EdgeInsets.only(bottom: 10),
          unselectedLabelColor: Colors.black87,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: tabs.map((v) {
          return FutureBuilder(
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
                  _songList = NewSongList.fromJson(snapshot.data);
                  _newAlbumList = NewAlbumList.fromJson(snapshot.data);
                  return widget.isSong
                      ? _getMainWidget(context)
                      : _getAlbumWidget(context);
                default:
                  return null;
              }
            },
            future: widget.isSong
                ? HttpRequest.getNewSonglist(v.type)
                : HttpRequest.getNewAlbumlist(v.id),
          );
        }).toList(),
      ),
    );
  }

  _getMainWidget(context) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        contentPadding: EdgeInsets.only(top: 15, left: 10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            getSongPic(_songList.data.songlist[index].album.mid),
          ),
        ),
        title: Text(
          _songList.data.songlist[index].name,
        ),
        subtitle: Text(
          subtitleFormat(_songList.data.songlist[index]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Offstage(
          offstage: _songList.data.songlist[index].mv.vid.isEmpty,
          child: IconButton(
              icon: Icon(Icons.video_library),
              onPressed: () {
               // print(_songList.data.songlist[index].mv.vid);
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PlayMVBody(_songList.data.songlist[index].mv.vid)));
              }),
        ),
        onTap: () {
          songDetails = _songList.data.songlist;
          globalCurrentIndex = index;
          eventBus.fire(CurrentPlayAlbumEvent(_songList.data.songlist[index].album.mid));
          Navigator.of(context).pushNamed(Routes.PLAY_DETAIL);
        },
      ),
      itemCount: _songList.data.songlist.length,
    );
  }

  _getAlbumWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: GridView.builder(
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    AlbumDetailBody(_newAlbumList.data.albums[index].mid)));
          },
          child: Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        getSongPic(_newAlbumList.data.albums[index].mid),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5, right: 5),
                      child: Text(
                        _newAlbumList.data.albums[index].timePublic,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Text(
                  _newAlbumList.data.albums[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  singerFormat(_newAlbumList.data.albums[index].singers),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 4,
        ),
        itemCount: _newAlbumList.data.albums.length,
      ),
    );
  }

  singerFormat(List<Singer> singers) {
    String str = '';
    singers.forEach((singer) {
      str = '$str${singer.singerName}/';
    });
    return str.substring(0, str.length - 1);
  }

  _titleWidget() => Container(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (!widget.isSong) {
                  setState(() {
                    widget.isSong = true;
                  });
                }
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  color: widget.isSong ? Colors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '新歌',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.isSong) {
                  setState(() {
                    widget.isSong = false;
                  });
                }
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  color: widget.isSong ? Colors.transparent : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '新碟',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
}

class Tag {
  int type, id;
  String name, area;

  Tag({this.type, this.id, this.name, this.area});
}
