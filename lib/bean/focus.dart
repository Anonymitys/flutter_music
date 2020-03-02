class Focus {
  Data data;

  Focus({this.data});

  Focus.fromJson(Map<String, dynamic> json) {
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
  List<Content> content;

  Data({this.content});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = new List<Content>();
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  int id;
  JumpInfo jumpInfo;
  PicInfo picInfo;

  Content({this.id, this.jumpInfo, this.picInfo});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jumpInfo = json['jump_info'] != null
        ? new JumpInfo.fromJson(json['jump_info'])
        : null;
    picInfo = json['pic_info'] != null
        ? new PicInfo.fromJson(json['pic_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.jumpInfo != null) {
      data['jump_info'] = this.jumpInfo.toJson();
    }
    if (this.picInfo != null) {
      data['pic_info'] = this.picInfo.toJson();
    }
    return data;
  }
}

class JumpInfo {
  int id;
  String mid;
  String url;

  JumpInfo({this.id, this.mid, this.url});

  JumpInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mid = json['mid'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mid'] = this.mid;
    data['url'] = this.url;
    return data;
  }
}

class PicInfo {
  String mid;
  String url;

  PicInfo({this.mid, this.url});

  PicInfo.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mid'] = this.mid;
    data['url'] = this.url;
    return data;
  }
}

