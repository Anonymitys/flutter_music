import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music/app_routes.dart';
import 'package:flutter_music/body/music_museum.dart';
import 'package:flutter_music/body/music_video.dart';
import 'package:flutter_music/utils/event_bus_util.dart';
import 'package:flutter_music/utils/util.dart';

import 'body/play_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.red, primaryColor: Colors.white),
      routes: appRoutes.routes,
      onUnknownRoute: (settings) => appRoutes.onUnknowPage(settings),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentIndex = 0;
  var showPic = true;

  Widget _currentPage(int index) {
    switch (index) {
      case 0:
        return MusicMuseum();
        break;
      case 1:
        return MusicVideo();
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        showPic = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return showPic
        ? Image.network(
            "http://blog.mrabit.com/bing/today",
            fit: BoxFit.cover,
          )
        : Scaffold(
            body: _currentPage(_currentIndex),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12.0,
              currentIndex: _currentIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note),
                  title: Text('音乐馆'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_library),
                  title: Text('视频'),
                ),
                BottomNavigationBarItem(
                  icon: StreamBuilder<CurrentPlayAlbumEvent>(
                    stream: eventBus.on<CurrentPlayAlbumEvent>(),
                    initialData:
                        CurrentPlayAlbumEvent(getSongPic('0022PtPf4GT8MT')),
                    builder: (context, snapshot) => ClipOval(
                      child: Image.network(
                        getSongPic(snapshot.data.url),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  title: Offstage(
                    offstage: true,
                    child: Text(''),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.radio),
                  title: Text('电台'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text('我的'),
                ),
              ],
              onTap: (index) {
                if (index == 2) {
                   Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PlayDetailBody()));
                } else {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
            ),
          );
  }
}
