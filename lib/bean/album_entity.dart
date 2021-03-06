import 'package:flutter_music/bean/cd_list.dart';
import 'package:flutter_music/bean/singer_entity.dart';
import 'package:flutter_music/bean/song_detail.dart';

import 'mv_entity.dart';

class Album {
  int id;
  String mid;
  String name;
  String title;
  String subtitle;
  String timePublic;
  String pMid;
  List<Singer> singers;

  Album(
      {this.id,
      this.mid,
      this.name,
      this.title,
      this.subtitle,
      this.timePublic,
      this.pMid,
      this.singers});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['albumID'];
    mid = json['mid'] ?? json['albumMid'];
    name = json['name'] ?? json['albumName'];
    title = json['title'];
    subtitle = json['subtitle'];
    timePublic =
        json['time_public'] ?? json['release_time'] ?? json['publishDate'];
    pMid = json['pmid'];
    if (json['singers'] != null) {
      singers = List<Singer>();
      json['singers'].forEach((v) {
        singers.add(Singer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mid'] = this.mid;
    data['name'] = this.name;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['time_public'] = this.timePublic;
    data['pid'] = this.pMid;
    if (this.singers != null) {
      data['singers'] = this.singers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlbumInfo {
  String albumMid;
  int totalNum;
  List<SongList> songList;

  AlbumInfo({this.albumMid, this.totalNum, this.songList});

  AlbumInfo.fromJson(Map<String, dynamic> json) {
    albumMid = json['albumMid'];
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
    data['albumMid'] = this.albumMid;
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
    songInfo =
        json['songInfo'] != null ? SongInfo.fromJson(json['songInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.songInfo != null) {
      data['songInfo'] = this.songInfo.toJson();
    }
    return data;
  }
}

class SongInfo implements Songlist{
  int id;
  String mid;
  String name;
  String title;
  String subtitle;
  List<Singer> singer;
  Album album;
  MV mv;
  String timePublic;

  SongInfo(
      {this.id,
      this.mid,
      this.name,
      this.title,
      this.subtitle,
      this.singer,
      this.album,
      this.mv,
      this.timePublic});

  SongInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mid = json['mid'];
    name = json['name'];
    title = json['title'];
    subtitle = json['subtitle'];
    if (json['singer'] != null) {
      singer = new List<Singer>();
      json['singer'].forEach((v) {
        singer.add(new Singer.fromJson(v));
      });
    }
    album = json['album'] != null ? Album.fromJson(json['album']) : null;
    mv = json['mv'] != null ? MV.fromJson(json['mv']) : null;
    timePublic = json['time_public'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mid'] = this.mid;
    data['name'] = this.name;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    if (this.singer != null) {
      data['singer'] = this.singer.map((v) => v.toJson()).toList();
    }
    if (this.album != null) {
      data['album'] = this.album.toJson();
    }
    if (this.mv != null) {
      data['mv'] = this.mv.toJson();
    }
    data['time_public'] = this.timePublic;
    return data;
  }

  @override
  String getAlbumMid() {
    return album.mid;
  }

  @override
  String getAlbumName() {
    return album.name;
  }

  @override
  List<Singer> getSingers() {
    return singer;
  }

  @override
  String getSongMid() {
    return mid;
  }

  @override
  String getSongName() {
    return title;
  }

  @override
  String albumdesc;

  @override
  int albumid;

  @override
  String albummid;

  @override
  String albumname;

  @override
  int songid;

  @override
  String songmid;

  @override
  String songname;

  @override
  String vid;

}


class AlbumDetail {
  AlbumSonglist albumSonglist;

  AlbumDetail({this.albumSonglist});

  AlbumDetail.fromJson(Map<String, dynamic> json) {
    albumSonglist = json['albumSonglist'] != null ? new AlbumSonglist.fromJson(json['albumSonglist']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.albumSonglist != null) {
      data['albumSonglist'] = this.albumSonglist.toJson();
    }
    return data;
  }
}

class AlbumSonglist {
  AlbumInfo albumInfo;

  AlbumSonglist({this.albumInfo});

  AlbumSonglist.fromJson(Map<String, dynamic> json) {
    albumInfo = json['data'] != null ? new AlbumInfo.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.albumInfo != null) {
      data['data'] = this.albumInfo.toJson();
    }
    return data;
  }
}