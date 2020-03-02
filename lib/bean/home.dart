import 'package:flutter_music/bean/group_top_list.dart';
import 'package:flutter_music/bean/new_album_list.dart';
import 'package:flutter_music/bean/focus.dart';
import 'package:flutter_music/bean/new_song_list.dart';
import 'package:flutter_music/bean/official_play_list.dart';
import 'package:flutter_music/bean/recom_play_list.dart';

class MusicHome {
  RecomPlaylist recomPlaylist;
  OfficialPlaylist officialPlaylist;
  NewSongList newSongList;
  NewAlbumList newAlbumList;
  GroupTopList groupTopList;
  Focus focus;

  MusicHome.fromJson(Map<String, dynamic> json) {
    recomPlaylist = json['recomPlaylist'] != null
        ? RecomPlaylist.fromJson(json['recomPlaylist'])
        : null;
    officialPlaylist = json['playlist'] != null
        ? OfficialPlaylist.fromJson(json['playlist'])
        : null;
    newSongList = json['new_song'] != null
        ? NewSongList.fromJson(json['new_song'])
        : null;
    newAlbumList = json['new_album'] != null
        ? NewAlbumList.fromJson(json['new_album'])
        : null;
    groupTopList =
        json['toplist'] != null ? GroupTopList.fromJson(json['toplist']) : null;
    focus = json['focus'] != null ? Focus.fromJson(json['focus']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (recomPlaylist != null) {
      data['recomPlaylist'] = recomPlaylist.toJson();
    }
    if (officialPlaylist != null) {
      data['playlist'] = officialPlaylist.toJson();
    }
    if (newSongList != null) {
      data['new_song'] = newSongList.toJson();
    }
    if (newAlbumList != null) {
      data['new_album'] = newAlbumList.toJson();
    }
    if (groupTopList != null) {
      data['toplist'] = groupTopList.toJson();
    }
    if (focus != null) {
      data['focus'] = focus.toJson();
    }
    return data;
  }
}
