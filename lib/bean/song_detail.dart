


import 'package:flutter_music/bean/singer_entity.dart';

abstract class SongDetail{

  String getAlbumMid();

  String getAlbumName();

  String getSongMid();

  String getSongName();

  List<Singer> getSingers();

}