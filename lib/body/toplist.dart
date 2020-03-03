import 'package:flutter/material.dart';
import 'package:flutter_music/body/top_list_detail.dart';

import '../bean/group_top_list.dart';
import '../utils/util.dart';
import '../utils/util.dart';

class TopListBody extends StatelessWidget {
  List<GroupTop> groupTop;

  TopListBody({this.groupTop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音乐排行榜'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: CustomScrollView(
          slivers: <Widget>[
            _title(groupTop[0].groupName),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _peekGroup(
                  index,
                  (topId) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TopListDetailPage(topId)));
                  },
                ),
                childCount: groupTop[0].toplist.length,
              ),
            ),
            _title(groupTop[1].groupName),
            _gridBody(1),
            _title(groupTop[2].groupName),
            _gridBody(2),
            _title(groupTop[3].groupName),
            _gridBody(3),
            _title(''),
          ],
        ),
      ),
    );
  }

  _title(String name) {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        alignment: Alignment.centerLeft,
        child: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  _peekGroup(int index, void Function(int topId) callback) {
    return GestureDetector(
      onTap: () {
        callback(groupTop[0].toplist[index].topId);
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        padding: EdgeInsets.only(left: 5),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    groupTop[0].toplist[index].title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Container(
                    height: 80,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        return Container(
                          height: 25,
                          child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text:
                                      '${i + 1}. ${groupTop[0].toplist[index].song[i].title}',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 12),
                                  children: [
                                    TextSpan(
                                      text:
                                          ' - ${groupTop[0].toplist[index].song[i].singerName}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    )
                                  ])),
//                          Row(
//                            children: <Widget>[
//                              Text(
//                                  '${i + 1}. ${groupTop[0].toplist[index].song[i].title}'),
//                              Text(
//                                ' - ${groupTop[0].toplist[index].song[i].singerName}',
//                                style:
//                                    TextStyle(color: Colors.grey, fontSize: 12),
//                              )
//                            ],
//                          ),
                        );
                      },
                      itemCount: groupTop[0].toplist[index].song.length,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  child: Image.network(
                    getSongPic(groupTop[0].toplist[index].song[0].albumMid),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _areaGroup(int index, int type, void Function(int topId) callback) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        callback(groupTop[type].toplist[index].topId);
      },
      child: Container(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(groupTop[type].toplist[index].headPicUrl),
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
                      listenNum(groupTop[type].toplist[index].listenNum),
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
      ),
    );
  }

  _gridBody(int type) => SliverGrid(
        delegate: SliverChildBuilderDelegate(
            (context, index) => _areaGroup(index, type, (topId) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TopListDetailPage(topId)));
                }),
            childCount: groupTop[type].toplist.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
      );
}
