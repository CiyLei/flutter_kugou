import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/component/bloc/kugou_bloc.dart';

class KuGouBottomNavigation extends StatefulWidget {
  KuGouBottomNavigation({
    @required this.imgUrl,
    @required this.song,
    @required this.author,
    this.playerStream,
  });

  String imgUrl;
  String song;
  String author;
  Stream<PlaySongInfoBean> playerStream;

  @override
  _KuGouBottomNavigationState createState() => _KuGouBottomNavigationState();
}

class _KuGouBottomNavigationState extends State<KuGouBottomNavigation> {
  double progress;

  @override
  void initState() {
    super.initState();
    progress = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: PlaySongInfoBean(
          songInfo: null,
          duration: Duration(seconds: 0),
          position: Duration(seconds: 0),
          state: 0),
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
                          snapshot.data.songInfo != null && snapshot.data.position != null
                              ? snapshot.data.position.inSeconds
                              : 0,
                          snapshot.data.songInfo != null && snapshot.data.duration != null
                              ? snapshot.data.duration.inSeconds
                              : 0),
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
                                      snapshot.data.songInfo != null ? snapshot.data.songInfo.data.song_name : "酷狗音乐",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14.0),
                                    ),
                                    Text(
                                      snapshot.data.songInfo != null ? snapshot.data.songInfo.data.author_name : "就是歌多",
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
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.playlist_play),
                              onPressed: () {},
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: CircleAvatar(
                  radius: 31.0,
                  backgroundColor: Colors.grey[300],
                  child: snapshot.data.songInfo == null
                      ? CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Theme.of(context).primaryColor,
                        )
                      : CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(snapshot.data.songInfo.data.img),
                        ),
                ),
              ),
            ],
          ),
    );
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
            setState(() {
              this.progress = value.floorToDouble();
            });
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
