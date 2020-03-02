class Singer {
  int singerId;
  String singerMid;
  String singerName;
  String singerPic;

  Singer({this.singerId, this.singerMid, this.singerName, this.singerPic});

  Singer.fromJson(Map<String, dynamic> json) {
    singerId = json['singer_id'] ?? json['id'];
    singerMid = json['singer_mid'] ?? json['mid'];
    singerName = json['singer_name'] ?? json['name'];
    singerPic = json['singer_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['singer_id'] = this.singerId;
    data['singer_mid'] = this.singerMid;
    data['singer_name'] = this.singerName;
    data['singer_pic'] = this.singerPic;
    return data;
  }
}
