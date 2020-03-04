import 'package:flutter/material.dart';
import 'package:flutter_music/base_widget.dart';
import 'package:flutter_music/bean/mv_detail.dart';
import 'package:flutter_music/bean/mv_list_and_tag.dart';
import 'package:flutter_music/bean/top_mv_list.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/util.dart';

class MusicVideo extends StatefulWidget {
  @override
  State createState() => _MusicVideoState();
}

class _MusicVideoState extends State<MusicVideo> {
  var _futureBuilder;
  MVCategory _mvCategory;
  MV _mv;
  TopMVList _topMVList;

  @override
  void initState() {
    _futureBuilder = HttpRequest.getMVHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('视频'),
        elevation: 0,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('还没有开始网络请求');
            case ConnectionState.active:
              return Text('ConnectionState.active');
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              _mv = MV.fromJson(snapshot.data[0]);
              _topMVList = TopMVList.fromJson(snapshot.data[1]);
              _mvCategory = MVCategory.fromJson(snapshot.data[2]);
              print(_mv.data.mvlist[0].mvtitle);
              print(_topMVList.request.data.rankList[0].videoInfo.name);
              print(_mvCategory.mvList.data.list[0].title);
              return _getMVBody();
            default:
              return null;
          }
        },
        future: _futureBuilder,
      ),
    );
  }

  _getMVBody() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: CustomScrollView(
        slivers: <Widget>[
          title('MV精选', '更多', 0, () {
            print('hello world');
          }),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _gridItem(index, 0, (vid) {
                      print(vid);
                    }),
                childCount: 4),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: 9/8),
          ),
          _mvRankBanner(() {
            print("hello world");
          }),
          title('更多精彩MV', '分类', 0, () {
            print("hello world");
          }),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _gridItem(index, 1, (vid) {
                print(vid);
              }),
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }

  _gridItem(int index, int type, void Function(String vid) callback) {
    String vid, coverUrl, title, name;
    String duration = '';
    int listennum;
    if (type == 0) {
      vid = _mv.data.mvlist[index].vid;
      coverUrl = _mv.data.mvlist[index].picurl;
      title = _mv.data.mvlist[index].mvtitle;
      name = _mv.data.mvlist[index].singerName;
      listennum = _mv.data.mvlist[index].listennum;
    } else if (type == 1) {
      String tmpstr = '';
      vid = _mvCategory.mvList.data.list[index].vid;
      coverUrl = _mvCategory.mvList.data.list[index].picurl;
      title = _mvCategory.mvList.data.list[index].title;
      _mvCategory.mvList.data.list[index].singers.forEach((singer) {
        tmpstr = '$tmpstr${singer.name}/';
      });
      name = tmpstr.substring(0, tmpstr.length - 1);
      listennum = _mvCategory.mvList.data.list[index].playcnt;
      duration = _duration2String(_mvCategory.mvList.data.list[index].duration);
    }
    return GestureDetector(
      onTap: () {
        callback(vid);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, bottom: 5, right: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.missed_video_call,
                        color: Colors.white,
                      ),
                      Text(
                        listenNum(listennum),
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(child: Container()),
                      Text(
                        duration,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  _mvRankBanner(VoidCallback callback) => SliverToBoxAdapter(
        child: GestureDetector(
          onTap: () {
            callback();
          },
          child: Container(
            margin: EdgeInsets.only(top: 40, bottom: 20),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '排行榜',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Text(
                        '更新时间:${dateformat(_topMVList.request.data.lastUpdate)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    child: _imagePlay(_topMVList
                        .request.data.rankList[0].videoInfo.coverPic)),
              ],
            ),
          ),
        ),
      );

  _imagePlay(String imageUrl) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              imageUrl,
              width: 160,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          Icon(
            Icons.play_arrow,
            color: Colors.red,
            size: 46,
          ),
        ],
      );

  _duration2String(int duration) {
    String str = '';
    int minute = duration ~/ 60;
    int second = duration % 60;

    str = minute < 10 ? '0$minute' : '$minute';

    return '$str:${second < 10 ? '0$second' : '$second'}';
  }
}
