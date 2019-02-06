import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/component/base_state.dart';
import 'package:flutter_kugou/component/view/sing_images_loop.dart';
import 'package:flutter_kugou/view/player/player_bloc.dart';
import 'package:flutter_kugou/view/player/singer_images_bean.dart';

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
        StreamBuilder(
          initialData: List<String>(),
          stream: bloc.singerStream,
          builder: (_, AsyncSnapshot<List<String>> snapshot) {
            return SingImagesLoopView(
              snapshot.data,
              controller: _loopController,);
          },
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
              body: Text("123"),
            );
          },
        ),
      ],
    );
  }
}
