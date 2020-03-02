import 'package:flutter_music/bean/singer_entity.dart';

class Song {
  int id;
  String mid;
  String name;
  String title;
  String subtitle;
  List<Singer> singer;

  Song(
      {this.id, this.mid, this.name, this.title, this.subtitle, this.singer});

  Song.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mid = json['mid'];
    name = json['name'];
    title = json['title'];
    subtitle = json['subtitle'];
    if (json['singer'] != null) {
      singer = List<Singer>();
      json['singer'].forEach((v) {
        singer.add(Singer.fromJson(v));
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
    if (this.singer != null) {
      data['singer'] = this.singer.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
