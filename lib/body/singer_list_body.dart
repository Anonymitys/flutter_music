import 'package:flutter/material.dart';
import 'package:flutter_music/bean/singer_list.dart';
import 'package:flutter_music/body/singer_detail_body.dart';

import '../network/network_util.dart';
import '../network/network_util.dart';

class SingerListBody extends StatefulWidget {
  @override
  State createState() => _SingerListState();
}

class _SingerListState extends State<SingerListBody> {
  SingerContent _singerContent;
  TabController _controller;

  var tabs = [
    Tag(id: 200, name: '内地'),
    Tag(id: 2, name: '港台'),
    Tag(id: 5, name: '欧美'),
    Tag(id: 4, name: '日本'),
    Tag(id: 3, name: '韩国'),
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
        title: Text('歌手排行榜'),
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
                    _singerContent = SingerContent.fromJson(snapshot.data);
                    return _getMainWidget(context);
                  default:
                    return null;
                }
              },
              future: HttpRequest.getSingerList(v.id));
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
              _singerContent.singerList.data.singerlist[index].singerPic),
        ),
        title:
            Text(_singerContent.singerList.data.singerlist[index].singerName),
        onTap: () {
          var singerMid =
              _singerContent.singerList.data.singerlist[index].singerMid;
          var singerName =
              _singerContent.singerList.data.singerlist[index].singerName;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SingerDetailBody(singerMid, singerName)));
        },
      ),
      itemCount: _singerContent.singerList.data.singerlist.length,
    );
  }
}
