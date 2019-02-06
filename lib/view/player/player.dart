import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/component/base_state.dart';
import 'package:flutter_kugou/component/view/sing_images_loop.dart';
import 'package:flutter_kugou/view/player/player_bloc.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends BaseState<Player, PlayerBloc> {
  SingImagesLoopController _loopController;

  @override
  void initState() {
    super.initState();
    _loopController = SingImagesLoopController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingImagesLoopView(
          [
            "http://imge.kugou.com/v2/mobile_portrait/T1V8D5BCbb1RCvBVdK.jpg",
            "http://imge.kugou.com/v2/mobile_portrait/T1opC5BbLj1RCvBVdK.jpg",
            "http://imge.kugou.com/v2/mobile_portrait/T1_8K5ByWj1RCvBVdK.jpg",
          ],
          controller: _loopController,
        ),
        StreamBuilder(
          initialData: bloc.kuGouBloc.playerSongInfo,
          builder: (_, AsyncSnapshot<PlaySongInfoBean> snapshot) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: CupertinoNavigationBar(
                middle: Text(
                  snapshot.data.songInfo != null
                      ? snapshot.data.songInfo.data.song_name
                      : "",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                backgroundColor: Colors.transparent,
                border: Border.all(style: BorderStyle.none),
                actionsForegroundColor: Colors.white,
              ),
              body: Row(
                children: <Widget>[
                  RaisedButton(onPressed: () {
                    _loopController.loop();
                  }),RaisedButton(onPressed: () {
                    _loopController.pause();
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
