class MVUrl {
  List<String> freeflowUrl;

  MVUrl({this.freeflowUrl});

  MVUrl.fromJson(Map<String, dynamic> json) {
    freeflowUrl = json['freeflow_url'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['freeflow_url'] = this.freeflowUrl;
    return data;
  }
}
