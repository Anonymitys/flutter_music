import 'package:flutter/material.dart';
import 'package:flutter_music/bean/mv_detail.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/util.dart';

class MVListNewBody extends StatefulWidget {
  @override
  State createState() => _MVListState();
}

class _MVListState extends State<MVListNewBody> {

  TabController _controller;
  MV _mv;

  var tabs = [
    Tag(name: '推荐', lan: 'all'),
    Tag(name: '内地', lan: 'neidi'),
    Tag(name: '韩国', lan: 'korea'),
    Tag(name: '港台', lan: 'gangtai'),
    Tag(name: '欧美', lan: 'oumei'),
    Tag(name: '日本', lan: 'janpan'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: ScrollableState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MV最新速递'),
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
                    _mv = MV.fromJson(snapshot.data);
                    return _getMainWidget(context);
                  default:
                    return null;
                }
              },
              future: HttpRequest.getRecMVlist(v.lan));
        }).toList(),
      ),
    );
  }

  _getMainWidget(context) {
    return ListView.builder(
      itemBuilder: (context, index) => _mvItem(index, (vid){
        print(vid);
      }),
      itemCount: _mv.data.mvlist.length,
    );
  }

  _mvItem(int index, void Function(String vid) callback) {
    return GestureDetector(
      onTap: () {
        callback(_mv.data.mvlist[index].vid);
      },
      child: Container(
        margin: EdgeInsets.all(10),
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
                    fit: BoxFit.cover,
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
           Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _mv.data.mvlist[index].mvtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    singersFormat(_mv.data.mvlist[index].singers),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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


class Tag {
  String name, lan;

  Tag({this.name, this.lan});
}
