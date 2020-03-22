import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_music/bean/playlist_catagory.dart';
import 'package:flutter_music/body/play_list.dart';
import 'package:flutter_music/network/network_util.dart';

class PlaylistCatagoryBody extends StatefulWidget {
  @override
  State createState() => _PlaylistCatagoryState();
}

class _PlaylistCatagoryState extends State<PlaylistCatagoryBody> {
  var _futureBuilderFuture;
  PlaylistCatagory _catagory;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = HttpRequest.getPlaylistCatagory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('歌单分类'),
        centerTitle: true,
      ),
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
                _catagory = PlaylistCatagory.fromJson(snapshot.data);
                print(_catagory.data.categories[0].items[0].categoryName);
                return _getMainWidget(context);
              default:
                return null;
            }
          },
          future: _futureBuilderFuture),
    );
  }

  _getMainWidget(context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemBuilder: (context, index) => _ItemCatagory(context, index),
        itemCount: _catagory.data.categories.length,
      ),
    );
  }

  _ItemCatagory(BuildContext context, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              _catagory.data.categories[index].categoryGroupName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.5),
            itemBuilder: (context, subIndex) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PlayListBody(
                          _catagory.data.categories[index].items[subIndex]
                              .categoryId,
                          _catagory.data.categories[index].items[subIndex]
                              .categoryName,
                          5,
                        )));
              },
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red,width: 1),
                ),
                child: Center(
                  child: Html(
                    data: _catagory
                        .data.categories[index].items[subIndex].categoryName,
                    customTextAlign: (_) => TextAlign.center,
                  ),
                ),
              ),
            ),
            itemCount: _catagory.data.categories[index].items.length,
          ),
        ],
      ),
    );
  }
}
