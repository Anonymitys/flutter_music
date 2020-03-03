import 'singer_entity.dart';

class SingerContent {
  SingerList singerList;

  SingerContent({this.singerList});

  SingerContent.fromJson(Map<String, dynamic> json) {
    singerList = json['singerList'] != null
        ? new SingerList.fromJson(json['singerList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.singerList != null) {
      data['singerList'] = this.singerList.toJson();
    }
    return data;
  }
}

class SingerList {
  Data data;

  SingerList({this.data});

  SingerList.fromJson(Map<String, dynamic> json) {
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
  List<Singer> singerlist;
  Tags tags;

  Data({this.singerlist, this.tags});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['singerlist'] != null) {
      singerlist = new List<Singer>();
      json['singerlist'].forEach((v) {
        singerlist.add(Singer.fromJson(v));
      });
    }
    tags = json['tags'] != null ? new Tags.fromJson(json['tags']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.singerlist != null) {
      data['singerlist'] = this.singerlist.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags.toJson();
    }
    return data;
  }
}

class Tags {
  List<Tag> area;
  List<Tag> genre;
  List<Tag> index;
  List<Tag> sex;

  Tags({this.area, this.genre, this.index, this.sex});

  Tags.fromJson(Map<String, dynamic> json) {
    if (json['area'] != null) {
      area = new List<Tag>();
      json['area'].forEach((v) {
        area.add(Tag.fromJson(v));
      });
    }
    if (json['genre'] != null) {
      genre = new List<Tag>();
      json['genre'].forEach((v) {
        genre.add(Tag.fromJson(v));
      });
    }
    if (json['index'] != null) {
      index = new List<Tag>();
      json['index'].forEach((v) {
        index.add(Tag.fromJson(v));
      });
    }
    if (json['sex'] != null) {
      sex = new List<Tag>();
      json['sex'].forEach((v) {
        sex.add(Tag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.area != null) {
      data['area'] = this.area.map((v) => v.toJson()).toList();
    }
    if (this.genre != null) {
      data['genre'] = this.genre.map((v) => v.toJson()).toList();
    }
    if (this.index != null) {
      data['index'] = this.index.map((v) => v.toJson()).toList();
    }
    if (this.sex != null) {
      data['sex'] = this.sex.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tag {
  int id;
  String name;

  Tag({this.id, this.name});

  Tag.fromJson(Map<String, dynamic> json) {
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

