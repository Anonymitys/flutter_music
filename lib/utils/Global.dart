import 'package:flutter/material.dart';
import 'package:flutter_music/bean/album_entity.dart';
import 'package:flutter_music/bean/cd_list.dart';
import 'package:flutter_music/body/play_detail.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  OverlayState _overlaystates;
  OverlayEntry _overlayEntry;
  bool hide = false;
  List<SongList> songLists;
  List<Songlist> cdlists;
  static Global instance;
  int currentIndex = 0;
  bool isPlayList = true;

  static Global getInstance() {
    if (instance == null) instance = Global();
    return instance;
  }

  void insertGlobalWidget(BuildContext context) {
    _overlaystates = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) => _buildwidget(context));
    _overlaystates.insert(_overlayEntry);
  }

  void updateGlobalWidget(bool isHide,
      {List<SongList> songlist,
      List<Songlist> cdlist,
      int index,
      bool isPlaylist}) {
    this.songLists = songlist;
    this.cdlists = cdlist;
    this.currentIndex = index;
    this.isPlayList = isPlaylist;
    this.hide = isHide;
    _overlayEntry.markNeedsBuild();
  }

  _buildwidget(BuildContext context) {
    return Positioned(
      right: 10,
      top: 40,
      child: GestureDetector(
        onTap: () async{
          hide = true;
          _overlayEntry.markNeedsBuild();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PlayDetailBody(
                    this.isPlayList,
                    currentIndex,
                    cdlist: cdlists,
                    songlists: songLists,
                  )));
        },
        child: Offstage(
          offstage: hide,
          child: ClipOval(
            child: Image.network(
              getSongPic(getAlbumMid()),
              width: 30,
              height: 30,
            ),
          ),
        ),
      ),
    );
  }

  getAlbumMid() {
    if (isPlayList && cdlists != null) {
      return cdlists[currentIndex].albummid;
    } else if (!isPlayList && songLists != null) {
      return songLists[currentIndex].songInfo.album.mid;
    }
    return null;
  }
}
