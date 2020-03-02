import 'package:flutter_music/bean/album_entity.dart';

class NewSongList {
  Data data;

  NewSongList({this.data});

  NewSongList.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<SongInfo> songlist;

  Data({this.songlist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['songlist'] != null) {
      songlist = new List<SongInfo>();
      json['songlist'].forEach((v) {
        songlist.add(SongInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.songlist != null) {
      data['songlist'] = this.songlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



