class PlaylistCatagory {
  Data data;

  PlaylistCatagory({this.data});

  PlaylistCatagory.fromJson(Map<String, dynamic> json) {
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
  List<Categories> categories;

  Data({this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String categoryGroupName;
  List<Items> items;

  Categories({this.categoryGroupName, this.items});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryGroupName = json['categoryGroupName'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryGroupName'] = this.categoryGroupName;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  List<Allsorts> allsorts;
  int categoryId;
  String categoryName;
  int usable;

  Items({this.allsorts, this.categoryId, this.categoryName, this.usable});

  Items.fromJson(Map<String, dynamic> json) {
    if (json['allsorts'] != null) {
      allsorts = new List<Allsorts>();
      json['allsorts'].forEach((v) {
        allsorts.add(new Allsorts.fromJson(v));
      });
    }
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    usable = json['usable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allsorts != null) {
      data['allsorts'] = this.allsorts.map((v) => v.toJson()).toList();
    }
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['usable'] = this.usable;
    return data;
  }
}

class Allsorts {
  int sortId;
  String sortName;

  Allsorts({this.sortId, this.sortName});

  Allsorts.fromJson(Map<String, dynamic> json) {
    sortId = json['sortId'];
    sortName = json['sortName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sortId'] = this.sortId;
    data['sortName'] = this.sortName;
    return data;
  }
}

