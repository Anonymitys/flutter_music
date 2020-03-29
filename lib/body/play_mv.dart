import 'package:audioplayers/audioplayers.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/bean/mv_url.dart';
import 'package:flutter_music/bean/play_mv_info.dart';
import 'package:flutter_music/instance/audio_player.dart';
import 'package:flutter_music/network/network_util.dart';
import 'package:flutter_music/utils/util.dart';

class PlayMVBody extends StatefulWidget {
  var vid;

  PlayMVBody(this.vid);

  @override
  State createState() => _PlayMVState();
}

class _PlayMVState extends State<PlayMVBody> {
  List<MVInfo> _others = List();
  MVInfo _mvInfo;
  List<MVUrl> _mvUrls = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                print('还没有开始网络请求');
                return Text('还没有开始网络请求');
              case ConnectionState.active:
                print('active');
                return Text('ConnectionState.active');
              case ConnectionState.waiting:
                print('waiting');
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                print('done');
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                _mvUrls.clear();
                List<Map<String, dynamic>>.from(snapshot.data[0]).forEach((v) {
                  _mvUrls.add(MVUrl.fromJson(v));
                });

                _mvInfo = MVInfo.fromJson(snapshot.data[1]);
                print("mvinfo${_mvInfo.name}");

                _others.clear();
                List<Map<String, dynamic>>.from(snapshot.data[2]).forEach((v) {
                  _others.add(MVInfo.fromJson(v));
                });
                return _getMainWidget(context);
              default:
                return null;
            }
          },
          future: HttpRequest.getplayMvInfo(widget.vid)),
    );
  }

  _getMainWidget(context) {
    return Column(
      children: <Widget>[
        Container(child: VideoPlayWidget(getMvUrl(), _mvInfo.name)),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => itemMv(context, index),
            itemCount: _others.length,
          ),
        ),
      ],
    );
  }

  itemMv(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.vid = _others[index].vid;
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Row(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    _others[index].coverPic,
                    width: 160,
                    height: 90,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 5, bottom: 5),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.video_call,
                          color: Colors.white,
                        ),
                        Text(
                          listenNum(_others[index].playcnt),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
              ],
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            Flexible(child: Text(_others[index].name)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  getMvUrl() {
    String url;
    for (int i = _mvUrls.length - 1; i > 0; i--) {
      if (_mvUrls[i].freeflowUrl.length != 0) {
        url = _mvUrls[i].freeflowUrl[0];
        break;
      }
    }
    print(url);
    return url;
  }
}

class VideoPlayWidget extends StatefulWidget {
  final url;
  final mvName;

  VideoPlayWidget(this.url, this.mvName);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<VideoPlayWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AwsomeVideoPlayer(
      widget.url,

      /// 视频播放配置
      playOptions: VideoPlayOptions(
          seekSeconds: 30,
          aspectRatio: 16 / 9,
          loop: true,
          autoplay: true,
          allowScrubbing: true,
          startPosition: Duration(seconds: 0)),

      /// 自定义视频样式
      videoStyle: VideoStyle(
        /// 暂停时是否显示视频中部播放按钮
        showPlayIcon: true,

        /// 自定义视频暂停时视频中部的播放按钮
        playIcon: Icon(
          Icons.play_arrow,
          size: 100,
          color: Colors.red,
        ),

        videoTopBarStyle: VideoTopBarStyle(
          padding: EdgeInsets.only(top: 5, left: 5),
          height: 46,
          contents: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.mvName,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),

        /// 自定义底部控制栏
        videoControlBarStyle: VideoControlBarStyle(
          /// 自定义颜色
          //barBackgroundColor: Colors.blue,
          /// 自定义进度条样式
          progressStyle: VideoProgressStyle(
              // padding: EdgeInsets.all(0),
              playedColor: Colors.red,
              //  bufferedColor: Colors.yellow,
              //  backgroundColor: Colors.green,
              dragBarColor: Colors.white54,
              //进度条为`progress`时有效，如果时`basic-progress`则无效
              height: 4,
              progressRadius: 2,
              //进度条为`progress`时有效，如果时`basic-progress`则无效
              dragHeight: 5 //进度条为`progress`时有效，如果时`basic-progress`则无效
              ),

          /// 更改进度栏的播放按钮
          playIcon: Icon(Icons.play_arrow, color: Colors.white, size: 16),

          /// 更改进度栏的暂停按钮
          pauseIcon: Icon(
            Icons.pause,
            color: Colors.white,
            size: 16,
          ),

          /// 更改进度栏的快退按钮
          rewindIcon: Icon(
            Icons.replay_30,
            size: 16,
            color: Colors.white,
          ),

          /// 更改进度栏的快进按钮
          forwardIcon: Icon(
            Icons.forward_30,
            size: 16,
            color: Colors.white,
          ),

          /// 更改进度栏的全屏按钮
          fullscreenIcon: Icon(
            Icons.fullscreen,
            size: 16,
            color: Colors.white,
          ),

          /// 更改进度栏的退出全屏按钮
          fullscreenExitIcon: Icon(
            Icons.fullscreen_exit,
            size: 16,
            color: Colors.white,
          ),

          /// 决定控制栏的元素以及排序，示例见上方图3
          itemList: [
            "rewind",
            "play",
            "forward",
            "position-time", //当前播放时间
            "progress", //线形进度条
            //"basic-progress",//矩形进度条
            "duration-time", //视频总时长
            // "time", //格式：当前时间/视频总时长
            "fullscreen"
          ],
        ),
      ),

      /// 自定义拓展元素
      children: [
        /// 这个将会覆盖的视频内容，因为这个层级是最高级，因此手势会失效(慎用)
        /// 这个可以用来做视频广告
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   bottom: 0,
        //   right: 0,
        //   child: Text("data", style: TextStyle(color: Colors.white),),
        // ),
      ],

      /// 视频初始化完成回调
      oninit: (val) {
        print("video oninit");
        if (audioPlayerUtil.getPlayState() == AudioPlayerState.PLAYING) {
          audioPlayerUtil.getAudioPlayer().pause();
        }
      },

      /// 视频播放回调
      onplay: (value) {
        print("video played");
      },

      /// 视频暂停回调
      onpause: (value) {
        print("video paused");
      },

      /// 视频播放结束回调
      onended: (value) {
        print("video ended");
      },

      /// 视频播放进度回调
      /// 可以用来匹配字幕
      ontimeupdate: (value) {
        var position = value.position.inMilliseconds / 1000;
        //根据 position 来判断当前显示的字幕
      },

      /// 声音变化回调
      onvolume: (value) {
        print("onvolume $value");
      },

      /// 亮度变化回调
      onbrightness: (value) {
        print("onbrightness $value");
      },

      /// 网络变化回调
      onnetwork: (value) {
        print("onbrightness $value");
      },

      /// 顶部控制栏点击返回按钮
      onpop: (value) {
        print("返回上一页");
        Navigator.pop(context);
      },
    );
  }
}
