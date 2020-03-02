class RecomPlaylist {
  Data data;

  RecomPlaylist({this.data});

  RecomPlaylist.fromJson(Map<String, dynamic> json) {
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
  List<VHot> vHot;

  Data({this.vHot});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['v_hot'] != null) {
      vHot = new List<VHot>();
      json['v_hot'].forEach((v) {
        vHot.add(new VHot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vHot != null) {
      data['v_hot'] = this.vHot.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VHot {
  String albumPicMid;
  int contentId;
  String cover;
  int creator;
  int id;
  int listenNum;
  String rcmdtemplate;
  String title;
  int type;
  String username;

  VHot(
      {this.albumPicMid,
        this.contentId,
        this.cover,
        this.creator,
        this.id,
        this.listenNum,
        this.rcmdtemplate,
        this.title,
        this.type,
        this.username});

  VHot.fromJson(Map<String, dynamic> json) {
    albumPicMid = json['album_pic_mid'];
    contentId = json['content_id'];
    cover = json['cover'];
    creator = json['creator'];
    id = json['id'];
    listenNum = json['listen_num'];
    rcmdtemplate = json['rcmdtemplate'];
    title = json['title'];
    type = json['type'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['album_pic_mid'] = this.albumPicMid;
    data['content_id'] = this.contentId;
    data['cover'] = this.cover;
    data['creator'] = this.creator;
    data['id'] = this.id;
    data['listen_num'] = this.listenNum;
    data['rcmdtemplate'] = this.rcmdtemplate;
    data['title'] = this.title;
    data['type'] = this.type;
    data['username'] = this.username;
    return data;
  }
}

