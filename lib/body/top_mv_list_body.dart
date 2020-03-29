import 'package:flutter/material.dart';
import 'package:flutter_music/bean/singer_list.dart';
import 'package:flutter_music/bean/top_mv_list.dart';
import 'package:flutter_music/body/play_mv.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/util.dart';

class TopMVListBody extends StatefulWidget {
  @override
  State createState() => _TopMVList();
}

class _TopMVList extends State<TopMVListBody> {
  TabController _controller;
  TopMVList _topMVList;

  var tabs = [
    Tag(id: 0, name: '总榜'),
    Tag(id: 1, name: '内地榜'),
    Tag(id: 5, name: '日本榜'),
    Tag(id: 3, name: '欧美榜'),
    Tag(id: 2, name: '港台榜'),
    Tag(id: 4, name: '韩国榜'),
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
        title: Text('MV排行榜'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          tabs: tabs.map((v) => Text(v.name)).toList(),
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
                    _topMVList = TopMVList.fromJson(snapshot.data);
                    return _getMainWidget(context);
                  default:
                    return null;
                }
              },
              future: HttpRequest.getTopMvlist(v.id));
        }).toList(),
      ),
    );
  }

  _getMainWidget(context) {
    return ListView.builder(
      itemBuilder: (context, index) => _itemMvwidget(context, index),
      itemCount: _topMVList.request.data.rankList.length,
    );
  }

  _itemMvwidget(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PlayMVBody(
                _topMVList.request.data.rankList[index].videoInfo.vid)));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                _topMVList.request.data.rankList[index].videoInfo.coverPic,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                left: 15,
                bottom: 15,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                )),
            Positioned(
              left: 10,
              top: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _topMVList.request.data.rankList[index].videoInfo.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    singersFormat(_topMVList
                        .request.data.rankList[index].videoInfo.singers),
                    maxLines: 1,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  singersFormat(List<Singers> singers) {
    String str = '';
    singers.forEach((singer) {
      str = '$str${singer.name}/';
    });
    return '${str.substring(0, str.length - 1)}';
  }
}
