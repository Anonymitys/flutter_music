class TopMVList {
  Request request;

  TopMVList({this.request});

  TopMVList.fromJson(Map<String, dynamic> json) {
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.request != null) {
      data['request'] = this.request.toJson();
    }
    return data;
  }
}

class Request {
  Data data;

  Request({this.data});

  Request.fromJson(Map<String, dynamic> json) {
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
  String lastUpdate;
  List<RankList> rankList;

  Data({this.lastUpdate, this.rankList});

  Data.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['last_update'];
    if (json['rank_list'] != null) {
      rankList = new List<RankList>();
      json['rank_list'].forEach((v) {
        rankList.add(new RankList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_update'] = this.lastUpdate;
    if (this.rankList != null) {
      data['rank_list'] = this.rankList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RankList {
  VideoInfo videoInfo;

  RankList({this.videoInfo});

  RankList.fromJson(Map<String, dynamic> json) {
    videoInfo = json['video_info'] != null
        ? new VideoInfo.fromJson(json['video_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videoInfo != null) {
      data['video_info'] = this.videoInfo.toJson();
    }
    return data;
  }
}

class VideoInfo {
  String coverPic;
  String name;
  int pubdate;
  List<Singers> singers;
  String vid;

  VideoInfo({this.coverPic, this.name, this.pubdate, this.singers, this.vid});

  VideoInfo.fromJson(Map<String, dynamic> json) {
    coverPic = json['cover_pic'];
    name = json['name'];
    pubdate = json['pubdate'];
    if (json['singers'] != null) {
      singers = new List<Singers>();
      json['singers'].forEach((v) {
        singers.add(new Singers.fromJson(v));
      });
    }
    vid = json['vid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover_pic'] = this.coverPic;
    data['name'] = this.name;
    data['pubdate'] = this.pubdate;
    if (this.singers != null) {
      data['singers'] = this.singers.map((v) => v.toJson()).toList();
    }
    data['vid'] = this.vid;
    return data;
  }
}

class Singers {
  int id;
  String mid;
  String name;
  String picMid;
  String picurl;

  Singers({this.id, this.mid, this.name, this.picMid, this.picurl});

  Singers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mid = json['mid'];
    name = json['name'];
    picMid = json['pic_mid'];
    picurl = json['picurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mid'] = this.mid;
    data['name'] = this.name;
    data['pic_mid'] = this.picMid;
    data['picurl'] = this.picurl;
    return data;
  }
}

