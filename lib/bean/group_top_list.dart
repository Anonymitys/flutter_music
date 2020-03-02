class GroupTopList {
  Data data;

  GroupTopList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) this.data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    if (this.data != null) {
      map['data'] = this.data.toJson();
    }
    return map;
  }
}

class Data {
  List<GroupTop> groupTop;

  Data.fromJson(Map<String, dynamic> json) {
    if (json['group'] != null) {
      groupTop = List<GroupTop>();
      json['group'].forEach((v) {
        groupTop.add(GroupTop.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.groupTop != null) {
      data['group'] = this.groupTop.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupTop {
  int groupId;
  String groupName;
  List<Toplist> toplist;

  GroupTop({this.groupId, this.groupName, this.toplist});

  GroupTop.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    if (json['toplist'] != null) {
      toplist = new List<Toplist>();
      json['toplist'].forEach((v) {
        toplist.add(new Toplist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['groupName'] = this.groupName;
    if (this.toplist != null) {
      data['toplist'] = this.toplist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Toplist {
  int topId;
  int recType;
  String title;
  String intro;
  String updateTime;
  int listenNum;
  int totalNum;
  List<Song> song;
  String headPicUrl;
  String adJumpUrl;
  String h5JumpUrl;
  String urlKey;
  String urlParams;

  Toplist(
      {this.topId,
      this.recType,
      this.title,
      this.intro,
      this.updateTime,
      this.listenNum,
      this.totalNum,
      this.song,
      this.headPicUrl,
      this.adJumpUrl,
      this.h5JumpUrl,
      this.urlKey,
      this.urlParams});

  Toplist.fromJson(Map<String, dynamic> json) {
    topId = json['topId'];
    recType = json['recType'];
    title = json['title'];
    intro = json['intro'];
    updateTime = json['updateTime'];
    listenNum = json['listenNum'];
    totalNum = json['totalNum'];
    if (json['song'] != null) {
      song = new List<Song>();
      json['song'].forEach((v) {
        song.add(new Song.fromJson(v));
      });
    }
    headPicUrl = json['headPicUrl'];
    adJumpUrl = json['adJumpUrl'];
    h5JumpUrl = json['h5JumpUrl'];
    urlKey = json['url_key'];
    urlParams = json['url_params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topId'] = this.topId;
    data['recType'] = this.recType;
    data['title'] = this.title;
    data['intro'] = this.intro;
    data['updateTime'] = this.updateTime;
    data['listenNum'] = this.listenNum;
    data['totalNum'] = this.totalNum;
    if (this.song != null) {
      data['song'] = this.song.map((v) => v.toJson()).toList();
    }
    data['headPicUrl'] = this.headPicUrl;
    data['adJumpUrl'] = this.adJumpUrl;
    data['h5JumpUrl'] = this.h5JumpUrl;
    data['url_key'] = this.urlKey;
    data['url_params'] = this.urlParams;
    return data;
  }
}

class Song {
  int songId;
  String vid;
  String albumMid;
  String title;
  String singerName;
  String singerMid;

  Song(
      {this.songId,
      this.vid,
      this.albumMid,
      this.title,
      this.singerName,
      this.singerMid});

  Song.fromJson(Map<String, dynamic> json) {
    songId = json['songId'];
    vid = json['vid'];
    albumMid = json['albumMid'];
    title = json['title'];
    singerName = json['singerName'];
    singerMid = json['singerMid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['songId'] = this.songId;
    data['vid'] = this.vid;
    data['albumMid'] = this.albumMid;
    data['title'] = this.title;
    data['singerName'] = this.singerName;
    data['singerMid'] = this.singerMid;
    return data;
  }
}
