class RadioGroup {

  List<GroupList> groupList;
  RadioGroup({this.groupList});

  RadioGroup.fromJson(Map<String, dynamic> json) {
    if (json['groupList'] != null) {
      groupList = new List<GroupList>();
      json['groupList'].forEach((v) {
        groupList.add(new GroupList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.groupList != null) {
      data['groupList'] = this.groupList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupList {
  String name;
  List<RadioList> radioList;

  GroupList({this.name, this.radioList});

  GroupList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['radioList'] != null) {
      radioList = new List<RadioList>();
      json['radioList'].forEach((v) {
        radioList.add(new RadioList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.radioList != null) {
      data['radioList'] = this.radioList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RadioList {
  String listenNum;
  String radioId;
  String radioImg;
  String radioName;

  RadioList({this.listenNum, this.radioId, this.radioImg, this.radioName});

  RadioList.fromJson(Map<String, dynamic> json) {
    listenNum = json['listenNum'];
    radioId = json['radioId'];
    radioImg = json['radioImg'];
    radioName = json['radioName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listenNum'] = this.listenNum;
    data['radioId'] = this.radioId;
    data['radioImg'] = this.radioImg;
    data['radioName'] = this.radioName;
    return data;
  }
}

