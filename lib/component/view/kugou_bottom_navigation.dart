import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/component/bloc/kugou_bloc.dart';
import 'package:flutter_kugou/component/net/network_image.dart';
import 'package:flutter_kugou/component/utils/view.dart';
import 'package:flutter_kugou/view/player/player.dart';
import 'dart:math';

import 'package:flutter_kugou/view/player/player_bloc.dart';

class KuGouBottomNavigation extends StatefulWidget {
  KuGouBottomNavigation({
    this.playerStream,
  });

  String imgUrl;
  String song;
  String author;
  Stream<PlaySongInfoBean> playerStream;

  @override
  _KuGouBottomNavigationState createState() => _KuGouBottomNavigationState();
}

class _KuGouBottomNavigationState extends State<KuGouBottomNavigation>
    with TickerProviderStateMixin {
  // 1为播放 0为暂停
  int currentPlayerState = 0;
  AnimationController _avatarController;
  AnimationController _hideController;

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(
        vsync: this, upperBound: 2 * pi, duration: const Duration(seconds: 60));
    _avatarController.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _avatarController.reset();
        _avatarController.forward();
      }
    });
    widget.playerStream.listen((PlaySongInfoBean bean) {
      if (bean.state != currentPlayerState && bean.state == 0)
        _avatarController.stop();
      else if (bean.state != currentPlayerState && bean.state == 1)
        _avatarController.forward();
      currentPlayerState = bean.state;
    });
    _hideController = AnimationController(
        vsync: this,
        upperBound: 65.0,
        duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _hideController,
        builder: (_, _c) => Transform.translate(
              offset: Offset(0, _hideController.value),
              child: _buildContent(context),
            ));
  }

  StreamBuilder<PlaySongInfoBean> _buildContent(BuildContext context) {
    return StreamBuilder(
      initialData: PlaySongInfoBean(state: 0),
      stream: widget.playerStream,
      builder: (_, AsyncSnapshot<PlaySongInfoBean> snapshot) => Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[100], offset: Offset(0.0, -1.0))
                  ],
                ),
                height: 60.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 75.0),
                  child: Column(
                    children: <Widget>[
                      _buildProgress(
                          context,
                          snapshot.data.songInfo != null &&
                                  snapshot.data.position != null
                              ? snapshot.data.position.inSeconds
                              : 0,
                          snapshot.data.songInfo != null &&
                                  snapshot.data.duration != null
                              ? snapshot.data.duration.inSeconds
                              : 100),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.songInfo != null
                                          ? snapshot
                                              .data.songInfo.data.song_name
                                          : "酷狗音乐",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14.0),
                                    ),
                                    Text(
                                      snapshot.data.songInfo != null
                                          ? snapshot
                                              .data.songInfo.data.author_name
                                          : "就是歌多",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                snapshot.data.state == 0
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                size: 35.0,
                              ),
                              padding: EdgeInsets.zero,
//                        iconSize: 40.0,
                              onPressed: () {
                                if (snapshot.data.state == 0) {
                                  BlocProvider.of<KuGouBloc>(context).play();
                                } else {
                                  BlocProvider.of<KuGouBloc>(context).pause();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next),
                              onPressed: () {
                                BlocProvider.of<KuGouBloc>(context).playNext();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.playlist_play),
                              onPressed: () {
                                print(BlocProvider.of<KuGouBloc>(context).playStream == widget.playerStream);
                                ViewUtils.showPlayerList(context, BlocProvider.of<KuGouBloc>(context));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _buildAvatar(context, snapshot),
            ],
          ),
    );
  }

  Padding _buildAvatar(
      BuildContext context, AsyncSnapshot<PlaySongInfoBean> snapshot) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
      child: AnimatedBuilder(
          animation: _avatarController,
          builder: (_, _c) => Transform.rotate(
                angle: _avatarController.value,
                child: GestureDetector(
                  onTap: () {
                    _openPlayer(context);
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    child: CircleAvatar(
                      radius: 32.0,
                      backgroundColor: Colors.grey[300],
                      child: snapshot.data.songInfo == null
                          ? CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.grey,
                            )
                          : CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                              MyNetworkImage(snapshot.data.songInfo.data.img),
                            ),
                    ),
                  ),
                ),
              )),
    );
  }

  void _openPlayer(BuildContext context) async {
    _hideController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    final double screenHeight = MediaQuery.of(context).size.height;
    final PlayerBloc _b = PlayerBloc(BlocProvider.of<KuGouBloc>(context));
    Navigator.of(context)
        .push(PageRouteBuilder(
      pageBuilder: (_, animation, _1) {
        return AnimatedBuilder(
            animation: animation,
            builder: (_, _c) => Transform.rotate(
                  alignment: Alignment.bottomCenter,
                  origin: Offset(0, screenHeight / 2),
                  angle: (1.0 - animation.value) * pi / 2,
                  child: BlocProvider<PlayerBloc>(
                    child: Player(),
                    bloc: _b,
                  ),
                ));
      },
      transitionDuration: const Duration(milliseconds: 500),
    ))
        .then((_) {
      (() async {
        await Future.delayed(const Duration(milliseconds: 200));
        _hideController.reverse();
      })();
    });
  }

  Widget _buildProgress(BuildContext context, int position, int duration) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      height: 15.0,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Theme.of(context).primaryColor,
          inactiveTrackColor: Colors.grey,
          thumbColor: Theme.of(context).primaryColor,
          activeTickMarkColor: Theme.of(context).primaryColor,
          inactiveTickMarkColor: Colors.grey,
        ),
        child: Slider(
          value: position.toDouble(),
          onChanged: (value) {
            BlocProvider.of<KuGouBloc>(context).seek(value);
          },
          label: "${position ~/ 60}:${position % 60}",
          min: 0.0,
          max: duration.toDouble(),
          divisions: 100,
        ),
      ),
    );
  }

}
