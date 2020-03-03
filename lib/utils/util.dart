import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

import '../bean/album_entity.dart';

listenNum(int num) {
  if (num > 10000) {
    return sprintf('%.1f万', [num / 10000.0]);
  }
  if (num > 100000000) {
    return sprintf('%.1f亿', [num / 100000000.0]);
  }

  return '$num';
}

dateformat(String date){

  var dateTime = DateTime.parse(date);
  return DateFormat('MM-dd').format(dateTime);
}


getSongPic(String albumMid) =>
    'https://y.gtimg.cn/music/photo_new/T002R300x300M000$albumMid.jpg?max_age=2592000';

subtitleFormat(SongInfo songInfo) {
  String str = '';
  songInfo.singer.forEach((singer) {
    str = '$str${singer.singerName}/';
  });
  return '${str.substring(0, str.length - 1)} · ${songInfo.album.name}';
}