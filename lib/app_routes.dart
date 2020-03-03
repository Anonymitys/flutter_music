import 'package:flutter/material.dart';
import 'package:flutter_music/body/singer_list_body.dart';
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
      };

  MaterialPageRoute onUnknowPage(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => UnknowPage(), settings: settings);
}

class Routes {
  static const String HOME_PAGE = '/';
  static const String SINGER_LIST = '/singer_list';
}
