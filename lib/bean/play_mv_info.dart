class MVInfo {
  String coverPic;
  String desc;
  String msg;
  String name;
  int playcnt;
  int pubdate;
  List<Singers> singers;
  String vid;

  MVInfo(
      {this.coverPic,
        this.desc,
        this.msg,
        this.name,
        this.playcnt,
        this.pubdate,
        this.singers,
        this.vid});

  MVInfo.fromJson(Map<String, dynamic> json) {
    coverPic = json['cover_pic'];
    desc = json['desc'];
    msg = json['msg'];
    name = json['name'];
    playcnt = json['playcnt'];
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
    data['desc'] = this.desc;
    data['msg'] = this.msg;
    data['name'] = this.name;
    data['playcnt'] = this.playcnt;
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

