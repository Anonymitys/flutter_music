class MV {
  Data data;

  MV({this.data});

  MV.fromJson(Map<String, dynamic> json) {
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
  List<Mvlist> mvlist;

  Data({this.mvlist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['mvlist'] != null) {
      mvlist = new List<Mvlist>();
      json['mvlist'].forEach((v) {
        mvlist.add(new Mvlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mvlist != null) {
      data['mvlist'] = this.mvlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mvlist {
  int listennum;
  int mvId;
  String mvdesc;
  String mvtitle;
  String picurl;
  String pubDate;
  int singerId;
  String singerMid;
  String singerName;
  int singerid;
  String singermid;
  String singername;
  List<Singers> singers;
  String vid;

  Mvlist(
      {this.listennum,
        this.mvId,
        this.mvdesc,
        this.mvtitle,
        this.picurl,
        this.pubDate,
        this.singerId,
        this.singerMid,
        this.singerName,
        this.singerid,
        this.singermid,
        this.singername,
        this.singers,
        this.vid});

  Mvlist.fromJson(Map<String, dynamic> json) {
    listennum = json['listennum'];
    mvId = json['mv_id'];
    mvdesc = json['mvdesc'];
    mvtitle = json['mvtitle'];
    picurl = json['picurl'];
    pubDate = json['pub_date'];
    singerId = json['singer_id'];
    singerMid = json['singer_mid'];
    singerName = json['singer_name'];
    singerid = json['singerid'];
    singermid = json['singermid'];
    singername = json['singername'];
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
    data['listennum'] = this.listennum;
    data['mv_id'] = this.mvId;
    data['mvdesc'] = this.mvdesc;
    data['mvtitle'] = this.mvtitle;
    data['picurl'] = this.picurl;
    data['pub_date'] = this.pubDate;
    data['singer_id'] = this.singerId;
    data['singer_mid'] = this.singerMid;
    data['singer_name'] = this.singerName;
    data['singerid'] = this.singerid;
    data['singermid'] = this.singermid;
    data['singername'] = this.singername;
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

  Singers({this.id, this.mid, this.name});

  Singers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mid = json['mid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mid'] = this.mid;
    data['name'] = this.name;
    return data;
  }
}

