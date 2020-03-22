import 'package:flutter/material.dart';
import 'package:flutter_music/body/mv_list_new.dart';
import 'package:flutter_music/body/official_playlist_list_body.dart';
import 'package:flutter_music/body/play_detail.dart';
import 'package:flutter_music/body/play_list_catagory_body.dart';
import 'package:flutter_music/body/singer_list_body.dart';
import 'package:flutter_music/body/song_album.dart';
import 'package:flutter_music/body/top_mv_list_body.dart';
import 'package:flutter_music/main.dart';
import 'package:flutter_music/unknow_page.dart';

var appRoutes = AppRoutes();

class AppRoutes {
  Map<String, WidgetBuilder> get routes => {
        Routes.HOME_PAGE: (_) => Builder(
            builder: (_) => MyHomePage(
                  title: '音乐馆',
                )),
        Routes.SINGER_LIST: (_) => SingerListBody(),
        Routes.OFFICIAL_PLAYLIST: (_) => OfficialPlaylistPage(),
        Routes.PLAY_LIST_CATAGORY: (_) => PlaylistCatagoryBody(),
        Routes.TOP_MV_LIST: (_) => TopMVListBody(),
        Routes.NEW_MV_LIST: (_) => MVListNewBody(),
        Routes.PLAY_DETAIL: (_) => PlayDetailBody(),
      };

  MaterialPageRoute onUnknowPage(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => UnknowPage(), settings: settings);
}

class Routes {
  static const String HOME_PAGE = '/';
  static const String SINGER_LIST = '/singer_list';
  static const String OFFICIAL_PLAYLIST = '/official_playlist';
  static const String PLAY_LIST_CATAGORY = '/play_list_catagory';
  static const String TOP_MV_LIST = '/top_mv_list';
  static const String NEW_MV_LIST = '/new_mv_list';
  static const String PLAY_DETAIL = '/play_detail';
}
