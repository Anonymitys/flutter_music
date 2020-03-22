// 歌单详情

import 'package:flutter_music/bean/singer_entity.dart';
import 'package:flutter_music/bean/song_detail.dart';
import 'package:flutter_music/bean/tag_entity.dart';

class PlayList {
  List<Cdlist> cdlist;

  PlayList({this.cdlist});

  PlayList.fromJson(Map<String, dynamic> json) {
    if (json['cdlist'] != null) {
      cdlist = List<Cdlist>();
      json['cdlist'].forEach((v) {
        cdlist.add(Cdlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.cdlist != null) {
      data['cdlist'] = this.cdlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cdlist {
  String disstid;
  String dissname;
  String logo;
  String picMid;
  String albumPicMid;
  int picDpi;
  String desc;
  int ctime;
  int mtime;
  String headurl;
  String nickname;
  List<Tags> tags;
  int totalSongNum;
  List<Songlist> songlist;

  Cdlist(
      {this.disstid,
      this.dissname,
      this.logo,
      this.picMid,
      this.albumPicMid,
      this.picDpi,
      this.desc,
      this.ctime,
      this.mtime,
      this.headurl,
      this.nickname,
      this.tags,
      this.totalSongNum,
      this.songlist});

  Cdlist.fromJson(Map<String, dynamic> json) {
    disstid = json['disstid'];
    dissname = json['dissname'];
    logo = json['logo'];
    picMid = json['pic_mid'];
    albumPicMid = json['album_pic_mid'];
    picDpi = json['pic_dpi'];
    desc = json['desc'];
    ctime = json['ctime'];
    mtime = json['mtime'];
    headurl = json['headurl'];
    nickname = json['nickname'];
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
    totalSongNum = json['total_song_num'];
    if (json['songlist'] != null) {
      songlist = new List<Songlist>();
      json['songlist'].forEach((v) {
        songlist.add(new Songlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['disstid'] = this.disstid;
    data['dissname'] = this.dissname;
    data['logo'] = this.logo;
    data['pic_mid'] = this.picMid;
    data['album_pic_mid'] = this.albumPicMid;
    data['pic_dpi'] = this.picDpi;
    data['desc'] = this.desc;
    data['ctime'] = this.ctime;
    data['mtime'] = this.mtime;
    data['headurl'] = this.headurl;
    data['nickname'] = this.nickname;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    data['total_song_num'] = this.totalSongNum;
    if (this.songlist != null) {
      data['songlist'] = this.songlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Songlist implements SongDetail{
  String albumdesc;
  int albumid;
  String albummid;
  String albumname;
  List<Singer> singer;
  int songid;
  String songmid;
  String songname;
  String vid;

  Songlist(
      {this.albumdesc,
      this.albumid,
      this.albummid,
      this.albumname,
      this.singer,
      this.songid,
      this.songmid,
      this.songname,
      this.vid});

  Songlist.fromJson(Map<String, dynamic> json) {
    albumdesc = json['albumdesc'];
    albumid = json['albumid'];
    albummid = json['albummid'];
    albumname = json['albumname'];
    if (json['singer'] != null) {
      singer = new List<Singer>();
      json['singer'].forEach((v) {
        singer.add(new Singer.fromJson(v));
      });
    }
    songid = json['songid'];
    songmid = json['songmid'];
    songname = json['songname'];
    vid = json['vid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['albumdesc'] = this.albumdesc;
    data['albumid'] = this.albumid;
    data['albummid'] = this.albummid;
    data['albumname'] = this.albumname;
    if (this.singer != null) {
      data['singer'] = this.singer.map((v) => v.toJson()).toList();
    }
    data['songid'] = this.songid;
    data['songmid'] = this.songmid;
    data['songname'] = this.songname;
    data['vid'] = this.vid;
    return data;
  }

  @override
  String getAlbumMid() {
    return albummid;
  }

  @override
  String getAlbumName() {
    return albumname;
  }

  @override
  List<Singer> getSingers() {
    return singer;
  }

  @override
  String getSongMid() {
    return songmid;
  }

  @override
  String getSongName() {
    return songname;
  }
}
