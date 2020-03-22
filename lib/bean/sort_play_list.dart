class SortPlayList {
  Data data;

  SortPlayList({this.data});

  SortPlayList.fromJson(Map<String, dynamic> json) {
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
  List<Lists> list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<Lists>();
      json['list'].forEach((v) {
        list.add(new Lists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lists {
  String dissid;
  String createtime;
  String commitTime;
  String dissname;
  String imgurl;
  String introduction;
  int listennum;

  Lists(
      {this.dissid,
        this.createtime,
        this.commitTime,
        this.dissname,
        this.imgurl,
        this.introduction,
        this.listennum});

  Lists.fromJson(Map<String, dynamic> json) {
    dissid = json['dissid'];
    createtime = json['createtime'];
    commitTime = json['commit_time'];
    dissname = json['dissname'];
    imgurl = json['imgurl'];
    introduction = json['introduction'];
    listennum = json['listennum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dissid'] = this.dissid;
    data['createtime'] = this.createtime;
    data['commit_time'] = this.commitTime;
    data['dissname'] = this.dissname;
    data['imgurl'] = this.imgurl;
    data['introduction'] = this.introduction;
    data['listennum'] = this.listennum;
    return data;
  }
}

