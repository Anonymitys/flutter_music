import 'album_entity.dart';

class NewAlbumList {
  Data data;

  NewAlbumList({this.data});

  NewAlbumList.fromJson(Map<String, dynamic> json) {
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
  List<Album> albums;

  Data({this.albums});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['albums'] != null) {
      albums = new List<Album>();
      json['albums'].forEach((v) {
        albums.add(Album.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.albums != null) {
      data['albums'] = this.albums.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




