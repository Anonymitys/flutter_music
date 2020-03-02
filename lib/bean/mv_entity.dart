class MV {
  int id;
  String vid;
  String name;
  String title;

  MV({this.id, this.vid, this.name, this.title});

  MV.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vid = json['vid'];
    name = json['name'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vid'] = this.vid;
    data['name'] = this.name;
    data['title'] = this.title;
    return data;
  }
}



class MVInfo {
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

  MVInfo(
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

  MVInfo.fromJson(Map<String, dynamic> json) {
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


