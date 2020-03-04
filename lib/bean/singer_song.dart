import 'album_entity.dart';

class SingerSong {
  SingerSongList singerSongList;

  SingerSong({this.singerSongList});

  SingerSong.fromJson(Map<String, dynamic> json) {
    singerSongList = json['singerSongList'] != null
        ? new SingerSongList.fromJson(json['singerSongList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.singerSongList != null) {
      data['singerSongList'] = this.singerSongList.toJson();
    }
    return data;
  }
}

class SingerSongList {
  Data data;

  SingerSongList({this.data});

  SingerSongList.fromJson(Map<String, dynamic> json) {
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
  String singerMid;
  int totalNum;
  List<SongList> songList;

  Data({this.singerMid, this.totalNum, this.songList});

  Data.fromJson(Map<String, dynamic> json) {
    singerMid = json['singerMid'];
    totalNum = json['totalNum'];
    if (json['songList'] != null) {
      songList = new List<SongList>();
      json['songList'].forEach((v) {
        songList.add(new SongList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['singerMid'] = this.singerMid;
    data['totalNum'] = this.totalNum;
    if (this.songList != null) {
      data['songList'] = this.songList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SongList {
  SongInfo songInfo;

  SongList({this.songInfo});

  SongList.fromJson(Map<String, dynamic> json) {
    songInfo = json['songInfo'] != null
        ? new SongInfo.fromJson(json['songInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.songInfo != null) {
      data['songInfo'] = this.songInfo.toJson();
    }
    return data;
  }
}



