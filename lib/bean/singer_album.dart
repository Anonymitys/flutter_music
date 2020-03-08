class SingerAlbum {
  GetAlbumList getAlbumList;

  SingerAlbum({this.getAlbumList});

  SingerAlbum.fromJson(Map<String, dynamic> json) {
    getAlbumList = json['getAlbumList'] != null
        ? new GetAlbumList.fromJson(json['getAlbumList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getAlbumList != null) {
      data['getAlbumList'] = this.getAlbumList.toJson();
    }
    return data;
  }
}

class GetAlbumList {
  Data data;

  GetAlbumList({this.data});

  GetAlbumList.fromJson(Map<String, dynamic> json) {
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
  List<AlbumList> albumList;
  int total;

  Data({this.singerMid, this.albumList, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    singerMid = json['singerMid'];
    if (json['albumList'] != null) {
      albumList = new List<AlbumList>();
      json['albumList'].forEach((v) {
        albumList.add(new AlbumList.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['singerMid'] = this.singerMid;
    if (this.albumList != null) {
      data['albumList'] = this.albumList.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class AlbumList {
  String albumMid;
  String albumName;
  String albumTranName;
  String publishDate;
  int totalNum;
  String albumType;
  String pmid;
  int albumID;
  String singerName;

  AlbumList(
      {this.albumMid,
        this.albumName,
        this.albumTranName,
        this.publishDate,
        this.totalNum,
        this.albumType,
        this.pmid,
        this.albumID,
        this.singerName});

  AlbumList.fromJson(Map<String, dynamic> json) {
    albumMid = json['albumMid'];
    albumName = json['albumName'];
    albumTranName = json['albumTranName'];
    publishDate = json['publishDate'];
    totalNum = json['totalNum'];
    albumType = json['albumType'];
    pmid = json['pmid'];
    albumID = json['albumID'];
    singerName = json['singerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['albumMid'] = this.albumMid;
    data['albumName'] = this.albumName;
    data['albumTranName'] = this.albumTranName;
    data['publishDate'] = this.publishDate;
    data['totalNum'] = this.totalNum;
    data['albumType'] = this.albumType;
    data['pmid'] = this.pmid;
    data['albumID'] = this.albumID;
    data['singerName'] = this.singerName;
    return data;
  }
}

