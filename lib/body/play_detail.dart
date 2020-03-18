import 'package:flutter/material.dart';
import 'package:flutter_music/bean/album_entity.dart';
import 'package:flutter_music/bean/cd_list.dart';
import 'package:flutter_music/utils/Global.dart';
import 'package:flutter_music/utils/util.dart';

class PlayDetailBody extends StatefulWidget {
  bool isPlayList;

  List<Songlist> cdlist;
  List<SongList> songlists;
  int currentIndex;

  PlayDetailBody(this.isPlayList, this.currentIndex,
      {this.cdlist, this.songlists});

  @override
  State createState() => _PlayDetailState();
}

class _PlayDetailState extends State<PlayDetailBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: Image.network(
            getSongPic(widget.cdlist[widget.currentIndex].albummid),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }


  @override
  void deactivate() {
    Global.getInstance().updateGlobalWidget(false,
        index: widget.currentIndex,
        songlist: widget.songlists,
        cdlist: widget.cdlist,
        isPlaylist: widget.isPlayList);
    super.deactivate();
  }


}
