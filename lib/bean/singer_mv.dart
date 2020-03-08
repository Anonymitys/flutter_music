class SingerMV {
  Data data;

  SingerMV({this.data});

  SingerMV.fromJson(Map<String, dynamic> json) {
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
  int total;

  Data({this.list, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<Lists>();
      json['list'].forEach((v) {
        list.add(new Lists.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Lists {
  String vid;
  String id;
  String title;
  String desc;
  String pic;
  String listenCount;
  String date;
  int singerId;
  String singerName;
  String singerMid;

  Lists(
      {this.vid,
        this.id,
        this.title,
        this.desc,
        this.pic,
        this.listenCount,
        this.date,
        this.singerId,
        this.singerName,
        this.singerMid});

  Lists.fromJson(Map<String, dynamic> json) {
    vid = json['vid'];
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    pic = json['pic'];
    listenCount = json['listenCount'];
    date = json['date'];
    singerId = json['singer_id'];
    singerName = json['singer_name'];
    singerMid = json['singer_mid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vid'] = this.vid;
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['pic'] = this.pic;
    data['listenCount'] = this.listenCount;
    data['date'] = this.date;
    data['singer_id'] = this.singerId;
    data['singer_name'] = this.singerName;
    data['singer_mid'] = this.singerMid;
    return data;
  }
}

