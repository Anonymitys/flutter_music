import 'dart:convert';

import 'package:dio/dio.dart';

var dio = Dio();

class HttpRequest {
  static Future<dynamic> getPlaylistDetail(int disstid) async {
    var response = await dio.get(
      API.PLAY_LIST_URL,
      queryParameters: {"type": 1, "disstid": disstid, "outCharset": "utf-8"},
      options: Options(
        headers: {"referer": "https://y.qq.com/n/yqq/playlist/$disstid.html"},
        responseType: ResponseType.plain,
      ),
    );
    var responseStr = response.data.toString();
    int start = responseStr.indexOf("(");
    int last = responseStr.lastIndexOf(")");
    String b = responseStr.substring(start + 1, last);
    return json.decode(b);
  }

  static Future<dynamic> getRecMV() async {
    var response = await dio.get(API.MV_URL, queryParameters: {
      "inCharset": "utf8",
      "outCharset": "utf8",
      "cmd": "shoubo",
      "lan": "all"
    });
    var responseStr = response.data.toString();
    int start = responseStr.indexOf("(");
    int last = responseStr.lastIndexOf(")");
    String b = responseStr.substring(start + 1, last);
    return json.decode(b);
  }

  static Future<dynamic> getMusicHome() async {
    List<Response> responses = await Future.wait([
      dio.post(
        API.BASE_URL,
        data: Body.MUSIC_HOME,
        options: Options(responseType: ResponseType.plain),
      ),
      dio.get(API.MV_URL, queryParameters: {
        "inCharset": "utf8",
        "outCharset": "GB2312",
        "cmd": "shoubo",
        "lan": "all"
      })
    ]);

    List<dynamic> list = List();
    list.add(json.decode(responses[0].data.toString()));

    var responseStr = responses[1].data.toString();
    int start = responseStr.indexOf("(");
    int last = responseStr.lastIndexOf(")");
    String b = responseStr.substring(start + 1, last);
    list.add(json.decode(b));

    return list;
  }

  static Future<dynamic> getMVHome() async {
    List<Response> responses = await Future.wait([
      dio.get(API.MV_URL, queryParameters: {
        "inCharset": "utf8",
        "outCharset": "utf8",
        "cmd": "shoubo",
        "lan": "all"
      }),
      dio.post(
        API.BASE_URL,
        data: Body.getTopMVlist(0),
        options: Options(responseType: ResponseType.plain),
      ),
      dio.post(
        API.BASE_URL,
        data: Body.MV_CATEGORY,
        options: Options(responseType: ResponseType.plain),
      ),
    ]);
    List<dynamic> list = List();
    var responseStr = responses[0].data.toString();
    int start = responseStr.indexOf("(");
    int last = responseStr.lastIndexOf(")");
    String b = responseStr.substring(start + 1, last);
    list.add(json.decode(b));

    list.add(json.decode(responses[1].data.toString()));

    list.add(json.decode(responses[2].data.toString()));

    return list;
  }

  static Future<dynamic> getTopListdDetail(int topId) async {
    var response = await dio.post(API.BASE_URL,
        data: Body.toplistDetail(topId),
        options: Options(responseType: ResponseType.plain));
    return jsonDecode(response.data.toString());
  }

  static Future<dynamic> getSingerList(int area) async {
    var response = await dio.post(API.BASE_URL,
        data: Body.singerList(area),
        options: Options(responseType: ResponseType.plain));
    return json.decode(response.data.toString());
  }

  static Future<dynamic> getSingerSong(String singerMid) async {
    var response = await dio.post(API.BASE_URL,
        data: Body.singerSong(singerMid),
        options: Options(responseType: ResponseType.plain));
    print(response.data.toString());
    return json.decode(response.data.toString());
  }

  static Future<dynamic> getSingerAlbum(String singerMid) async {
    var response = await dio.post(API.BASE_URL,
        data: Body.singerAlbum(singerMid),
        options: Options(responseType: ResponseType.plain));
    return json.decode(response.data.toString());
  }

  static Future<dynamic> getSingerMv(String singerMid) async {
    var response = await dio.get(API.MV_URL, queryParameters: {
      "inCharset": "utf8",
      "outCharset": "utf8",
      "cid": 205360581,
      "singermid": singerMid,
      "begin": 0,
      "num": 100
    });
    var responseStr = response.data.toString();
    int start = responseStr.indexOf("(");
    int last = responseStr.lastIndexOf(")");
    String b = responseStr.substring(start + 1, last);
    return json.decode(b);
  }

  static Future<dynamic> getSingerDetail(String singerMid) async {
    var responses = await Future.wait([
      dio.post(API.BASE_URL,
          data: Body.singerSong(singerMid),
          options: Options(responseType: ResponseType.plain)),
      dio.post(API.BASE_URL,
          data: Body.singerAlbum(singerMid),
          options: Options(responseType: ResponseType.plain)),
      dio.get(API.MV_SINGER, queryParameters: {
        "inCharset": "utf8",
        "outCharset": "utf8",
        "cid": 205360581,
        "singermid": singerMid,
        "order": "listen",
        "begin": 0,
        "num": 200
      })
    ]);

    List<dynamic> list = List();
    list.add(json.decode(responses[0].data.toString()));
    list.add(json.decode(responses[1].data.toString()));
    list.add(json.decode(responses[2].data.toString()));

    return list;
  }

  static Future<dynamic> getAlbumDetail(String albumMid) async {
    var response = await dio.post(API.BASE_URL,
        data: Body.albumDetail(albumMid),
        options: Options(responseType: ResponseType.plain));

    return json.decode(response.data.toString());
  }

  static Future<dynamic> getOfficialPlaylist() async {
    var response = await dio.post(API.BASE_URL,
        data: Body.OFFICIAL_PLAYLIST,
        options: Options(responseType: ResponseType.plain));
    return json.decode(response.data.toString());
  }

  static Future<dynamic> getNewSonglist(int type) async {
    var response = await dio.post(API.BASE_URL,
        data: Body.newSong(type),
        options: Options(responseType: ResponseType.plain));
    return json.decode(response.data.toString())["new_song"];
  }

  static Future<dynamic> getNewAlbumlist(int area) async {
    var response = await dio.post(API.BASE_URL,
        data: Body.newAlbum(area),
        options: Options(responseType: ResponseType.plain));
    return json.decode(response.data.toString())["new_album"];
  }

  static Future<dynamic> getPlaylistCatagory() async {
    var response = await dio.get(
      API.PLAY_LIST_CATAGORY,
      queryParameters: {"outCharset": "utf-8"},
      options: Options(
        headers: {"referer": "https://y.qq.com/portal/playlist.html"},
        responseType: ResponseType.plain,
      ),
    );
    var responseStr = response.data.toString();
    int start = responseStr.indexOf("(");
    int last = responseStr.lastIndexOf(")");
    String b = responseStr.substring(start + 1, last);
    return json.decode(b);
  }

  static Future<dynamic> getPlaylist(int categoryId, int sortId) async {
    var response = await dio.get(
      API.PLAY_LIST,
      queryParameters: {
        "outCharset": "utf-8",
        "categoryId": categoryId,
        "sortId": sortId,
        "sin": 0,
        "ein": 100
      },
      options: Options(
        headers: {"referer": "https://y.qq.com/portal/playlist.html"},
        responseType: ResponseType.plain,
      ),
    );
    var responseStr = response.data.toString();
    int start = responseStr.indexOf("(");
    int last = responseStr.lastIndexOf(")");
    String b = responseStr.substring(start + 1, last);
    return json.decode(b);
  }

  static Future<dynamic> getTopMvlist(int areaType) async {
    var response = await dio.post(
      API.BASE_URL,
      data: Body.getTopMVlist(areaType),
      options: Options(responseType: ResponseType.plain),
    );
    return json.decode(response.data.toString());
  }

  static Future<dynamic> getRecMVlist(String lan) async {
    var response = await dio.get(API.MV_URL, queryParameters: {
      "inCharset": "utf8",
      "outCharset": "GB2312",
      "cmd": "shoubo",
      "lan": lan
    });
    var responseStr = response.data.toString();
    int start = responseStr.indexOf("(");
    int last = responseStr.lastIndexOf(")");
    String b = responseStr.substring(start + 1, last);
    return json.decode(b);
  }

  static Future<dynamic> getvKey(String songMid) async {
    var response = await dio.post(
      API.BASE_URL,
      data: Body.getvKey(songMid),
      options: Options(responseType: ResponseType.plain),
    );
    return json.decode(response.data.toString())['req_0']['data']['midurlinfo'][0]['purl'];
  }

  static Future<dynamic> getMvUrl(String vid) async {
    var response = await dio.post(
      API.BASE_URL,
      data: Body.getmvUrl(vid),
      options: Options(responseType: ResponseType.plain),
    );
    return json.decode(response.data.toString())["getMvUrl"]["data"][vid]["mp4"];
  }

  static Future<dynamic> getMvInfo(String vid) async{
    var response = await dio.post(
      API.BASE_URL,
      data: Body.getplaymvInfo(vid),
      options: Options(responseType: ResponseType.plain),
    );
    return json.decode(response.data.toString());
  }

  static Future<dynamic> getplayMvInfo(String vid) async {
    var responses = await Future.wait([
      dio.post(API.BASE_URL,
          data: Body.getmvUrl(vid),
          options: Options(responseType: ResponseType.plain)),
      dio.post(API.BASE_URL,
          data: Body.getplaymvInfo(vid),
          options: Options(responseType: ResponseType.plain)),

    ]);
    List list = List();
    list.add(json.decode(responses[0].data.toString())["getMvUrl"]["data"][vid]["mp4"]);
    list.add(json.decode(responses[1].data.toString())["mvinfo"]["data"][vid]);
    list.add(json.decode(responses[1].data.toString())["other"]["data"]["list"]);

    return list;
  }


  static Future<dynamic> getRadioList() async{
    var response = await dio.get(API.RADIO_LIST,options: Options(responseType: ResponseType.plain));
    var responseStr = response.data.toString();
    int start = responseStr.indexOf("(");
    int last = responseStr.lastIndexOf(")");
    String b = responseStr.substring(start + 1, last);
    return json.decode(b)['data']['data'];
  }
}

class API {
  static const BASE_URL = 'https://u.y.qq.com/cgi-bin/musicu.fcg';
  static const PLAY_LIST_URL =
      'https://c.y.qq.com/qzone/fcg-bin/fcg_ucc_getcdinfo_byids_cp.fcg';
  static const MV_URL = 'https://c.y.qq.com/mv/fcgi-bin/getmv_by_tag';

  static const MV_SINGER = "https://c.y.qq.com/mv/fcgi-bin/fcg_singer_mv.fcg";

  static const PLAY_LIST_CATAGORY =
      "https://c.y.qq.com/splcloud/fcgi-bin/fcg_get_diss_tag_conf.fcg";

  static const PLAY_LIST =
      "https://c.y.qq.com/splcloud/fcgi-bin/fcg_get_diss_by_tag.fcg";

  static const RADIO_LIST = "https://c.y.qq.com/v8/fcg-bin/fcg_v8_radiolist.fcg";
}

class Body {
  static const MUSIC_HOME = {
    "recomPlaylist": {
      "method": "get_hot_recommend",
      "param": {"async": 1, "cmd": 2},
      "module": "playlist.HotRecommendServer"
    },
    "playlist": {
      "module": "playlist.PlayListPlazaServer",
      "method": "get_playlist_by_category",
      "param": {"id": 3317, "size": 12, "titleid": 3317}
    },
    "new_song": {
      "module": "newsong.NewSongServer",
      "method": "get_new_song_info",
      "param": {"type": 5}
    },
    "new_album": {
      "module": "newalbum.NewAlbumServer",
      "method": "get_new_album_info",
      "param": {"area": 1, "sin": 0, "num": 10}
    },
    "toplist": {
      "module": "musicToplist.ToplistInfoServer",
      "method": "GetAll",
      "param": {}
    },
    "focus": {
      "module": "QQMusic.MusichallServer",
      "method": "GetFocus",
      "param": {}
    }
  };

  static getTopMVlist(int areaType) => {
        "request": {
          "method": "get_video_rank_list",
          "param": {
            "rank_type": 0,
            "area_type": areaType,
            "required": ["vid", "name", "singers", "cover_pic", "pubdate"]
          },
          "module": "video.VideoRankServer"
        }
      };

  static const MV_CATEGORY = {
    "mv_tag": {
      "module": "MvService.MvInfoProServer",
      "method": "GetAllocTag",
      "param": {}
    },
    "mv_list": {
      "module": "MvService.MvInfoProServer",
      "method": "GetAllocMvInfo",
      "param": {
        "start": 0,
        "size": 20,
        "version_id": 7,
        "area_id": 15,
        "order": 1
      }
    }
  };

  static toplistDetail(int topId) => {
        "detail": {
          "module": "musicToplist.ToplistInfoServer",
          "method": "GetDetail",
          "param": {"topId": topId, "offset": 0, "num": 100}
        }
      };

  static singerList(int area) => {
        "singerList": {
          "module": "Music.SingerListServer",
          "method": "get_singer_list",
          "param": {
            "area": area,
            "sex": -100,
            "genre": -100,
            "index": -100,
            "sin": 0,
            "cur_page": 1
          }
        }
      };

  static singerSong(String singerMid) => {
        "singerSongList": {
          "method": "GetSingerSongList",
          "param": {"order": 1, "singerMid": singerMid, "begin": 0, "num": 300},
          "module": "musichall.song_list_server"
        }
      };

  static singerAlbum(String singerMid) => {
        "getAlbumList": {
          "method": "GetAlbumList",
          "param": {"singerMid": singerMid, "order": 0, "begin": 0, "num": 100},
          "module": "music.musichallAlbum.AlbumListServer"
        }
      };

  static albumDetail(String albumMid) => {
        "albumSonglist": {
          "method": "GetAlbumSongList",
          "param": {
            "albumMid": albumMid,
            "albumID": 0,
            "begin": 0,
            "num": 100,
            "order": 2
          },
          "module": "music.musichallAlbum.AlbumSongList"
        }
      };

  static const OFFICIAL_PLAYLIST = {
    "playlist": {
      "module": "playlist.PlayListPlazaServer",
      "method": "get_playlist_by_category",
      "param": {"id": 3317, "size": 120, "titleid": 3317}
    },
  };

  static newSong(int type) => {
        "new_song": {
          "module": "newsong.NewSongServer",
          "method": "get_new_song_info",
          "param": {"type": type}
        }
      };

  static newAlbum(int area) => {
        "new_album": {
          "module": "newalbum.NewAlbumServer",
          "method": "get_new_album_info",
          "param": {"area": area, "sin": 0, "num": 100}
        }
      };

  static getvKey(String songMid) => {
        "req_0": {
          "module": "vkey.GetVkeyServer",
          "method": "CgiGetVkey",
          "param": {
            "guid": "7163709783",
            "songmid": [songMid],
            "uin": "0"
          }
        }
      };

  static getmvUrl(String vid)=>{
    "getMvUrl": {
      "module": "gosrf.Stream.MvUrlProxy",
      "method": "GetMvUrls",
      "param": {
        "vids": [vid],
        "request_typet": 10001,
        "addrtype": 3
      }
    }
  };

  static getplaymvInfo(String vid)=>{
    "mvinfo": {
      "module": "video.VideoDataServer",
      "method": "get_video_info_batch",
      "param": {
        "vidlist": [vid],
        "required": ["vid",  "cover_pic", "singers",  "msg", "name", "desc", "playcnt", "pubdate"]
      }
    },
    "other": {
      "module": "video.VideoLogicServer",
      "method": "rec_video_byvid",
      "param": {
        "vid": vid,
        "required": ["vid",   "cover_pic", "singers", "msg", "name", "desc", "playcnt", "pubdate",   "uploader_headurl", "uploader_nick"],
        "support": 1
      }
    }
  };
}
