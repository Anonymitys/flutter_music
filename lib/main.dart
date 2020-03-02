import 'package:flutter/material.dart';
import 'package:flutter_music/app_routes.dart';
import 'package:flutter_music/body/music_museum.dart';
import 'package:flutter_music/body/music_video.dart';
import 'package:flutter_music/body/recomend.dart';
import 'package:flutter_music/network/network_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.white,
      ),
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
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.radio),
            title: Text('电台'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('我的'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
