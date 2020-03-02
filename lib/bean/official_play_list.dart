class OfficialPlaylist {
  Data data;

  OfficialPlaylist({this.data});

  OfficialPlaylist.fromJson(Map<String, dynamic> json) {
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
  List<VPlaylist> vPlaylist;

  Data({this.vPlaylist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['v_playlist'] != null) {
      vPlaylist = new List<VPlaylist>();
      json['v_playlist'].forEach((v) {
        vPlaylist.add(new VPlaylist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vPlaylist != null) {
      data['v_playlist'] = this.vPlaylist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VPlaylist {
  int accessNum;
  String coverUrlBig;
  int createTime;
  int tid;
  String title;

  VPlaylist(
      {this.accessNum,
        this.coverUrlBig,
        this.createTime,
        this.tid,
        this.title});

  VPlaylist.fromJson(Map<String, dynamic> json) {
    accessNum = json['access_num'];
    coverUrlBig = json['cover_url_big'];
    createTime = json['create_time'];
    tid = json['tid'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_num'] = this.accessNum;
    data['cover_url_big'] = this.coverUrlBig;
    data['create_time'] = this.createTime;
    data['tid'] = this.tid;
    data['title'] = this.title;
    return data;
  }
}

