import 'album_entity.dart';

class TopListDetail {
  Detail detail;

  TopListDetail({this.detail});

  TopListDetail.fromJson(Map<String, dynamic> json) {
    detail = json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
    }
    return data;
  }
}

class Detail {
  Data data;

  Detail({this.data});

  Detail.fromJson(Map<String, dynamic> json) {
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
  DataSub dataSub;
  List<SongInfo> songInfoList;

  Data({this.dataSub, this.songInfoList});

  Data.fromJson(Map<String, dynamic> json) {
    dataSub = json['data'] != null ? new DataSub.fromJson(json['data']) : null;
    if (json['songInfoList'] != null) {
      songInfoList = new List<SongInfo>();
      json['songInfoList'].forEach((v) { songInfoList.add(SongInfo.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataSub != null) {
      data['data'] = this.dataSub.toJson();
    }
    if (this.songInfoList != null) {
      data['songInfoList'] = this.songInfoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataSub {
  int topId;
  int topType;
  int updateType;
  String title;
  String titleDetail;
  String intro;
  String period;
  String updateTime;
  int listenNum;
  int totalNum;
  String headPicUrl;
  String adShareContent;

  DataSub({this.topId, this.topType, this.updateType, this.title, this.titleDetail, this.intro, this.period, this.updateTime, this.listenNum, this.totalNum, this.headPicUrl, this.adShareContent});

  DataSub.fromJson(Map<String, dynamic> json) {
    topId = json['topId'];
    topType = json['topType'];
    updateType = json['updateType'];
    title = json['title'];
    titleDetail = json['titleDetail'];
    intro = json['intro'];
    period = json['period'];
    updateTime = json['updateTime'];
    listenNum = json['listenNum'];
    totalNum = json['totalNum'];
    headPicUrl = json['headPicUrl'];
    adShareContent = json['AdShareContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topId'] = this.topId;
    data['topType'] = this.topType;
    data['updateType'] = this.updateType;
    data['title'] = this.title;
    data['titleDetail'] = this.titleDetail;
    data['intro'] = this.intro;
    data['period'] = this.period;
    data['updateTime'] = this.updateTime;
    data['listenNum'] = this.listenNum;
    data['totalNum'] = this.totalNum;
    data['headPicUrl'] = this.headPicUrl;
    data['AdShareContent'] = this.adShareContent;
    return data;
  }
}


