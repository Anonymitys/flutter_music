class MVCategory {
  MVTag mvTag;
  MVList mvList;

  MVCategory({this.mvTag, this.mvList});

  MVCategory.fromJson(Map<String, dynamic> json) {
    mvTag = json['mv_tag'] != null ? MVTag.fromJson(json['mv_tag']) : null;
    mvList = json['mv_list'] != null ? MVList.fromJson(json['mv_list']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.mvTag != null) {
      data['mv_tag'] = this.mvTag.toJson();
    }
    if (this.mvList != null) {
      data['mv_list'] = this.mvList.toJson();
    }
    return data;
  }
}

class MVList {
  Data data;

  MVList({this.data});

  MVList.fromJson(Map<String, dynamic> json) {
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
        list.add(Lists.fromJson(v));
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
  int duration;
  int mvid;
  String picurl;
  int playcnt;
  int pubdate;
  List<Singers> singers;
  String subtitle;
  String title;
  String vid;

  Lists(
      {this.duration,
      this.mvid,
      this.picurl,
      this.playcnt,
      this.pubdate,
      this.singers,
      this.subtitle,
      this.title,
      this.vid});

  Lists.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    mvid = json['mvid'];
    picurl = json['picurl'];
    playcnt = json['playcnt'];
    pubdate = json['pubdate'];
    if (json['singers'] != null) {
      singers = List<Singers>();
      json['singers'].forEach((v) {
        singers.add(new Singers.fromJson(v));
      });
    }
    subtitle = json['subtitle'];
    title = json['title'];
    vid = json['vid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['mvid'] = this.mvid;
    data['picurl'] = this.picurl;
    data['playcnt'] = this.playcnt;
    data['pubdate'] = this.pubdate;
    if (this.singers != null) {
      data['singers'] = this.singers.map((v) => v.toJson()).toList();
    }
    data['subtitle'] = this.subtitle;
    data['title'] = this.title;
    data['vid'] = this.vid;
    return data;
  }
}

class Singers {
  int id;
  String mid;
  String name;
  String picurl;

  Singers({this.id, this.mid, this.name, this.picurl});

  Singers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mid = json['mid'];
    name = json['name'];
    picurl = json['picurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mid'] = this.mid;
    data['name'] = this.name;
    data['picurl'] = this.picurl;
    return data;
  }
}

class MVTag {
  List<Area> area;
  List<Version> version;

  MVTag({this.area, this.version});

  MVTag.fromJson(Map<String, dynamic> json) {
    if (json['area'] != null) {
      area = new List<Area>();
      json['area'].forEach((v) {
        area.add(new Area.fromJson(v));
      });
    }
    if (json['version'] != null) {
      version = new List<Version>();
      json['version'].forEach((v) {
        version.add(new Version.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.area != null) {
      data['area'] = this.area.map((v) => v.toJson()).toList();
    }
    if (this.version != null) {
      data['version'] = this.version.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Area {
  int id;
  String name;

  Area({this.id, this.name});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Version {
  int id;
  String name;

  Version({this.id, this.name});

  Version.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
