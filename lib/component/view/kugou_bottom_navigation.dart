import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/bean/play_song_list_info_bean.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/component/bloc/kugou_bloc.dart';
import 'dart:math';

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
    with SingleTickerProviderStateMixin {
  // 1为播放 0为暂停
  int currentPlayerState = 0;
  AnimationController _avatarController;
  double progress;

  @override
  void initState() {
    super.initState();
    progress = 0.0;
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
  }

  @override
  Widget build(BuildContext context) {
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
                                showPlayerList(context);
                              },
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
                child: AnimatedBuilder(
                    animation: _avatarController,
                    builder: (_, _c) => Transform.rotate(
                          angle: _avatarController.value,
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
                                backgroundImage: NetworkImage(
                                    snapshot.data.songInfo.data.img),
                              ),
                            ),
                          ),
                        )),
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

  void showPlayerList(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return _buildPlayerList(context, onOrderTap: () {
            print("切换顺序");
          }, onItemDeleteTap: (index) {
            BlocProvider.of<KuGouBloc>(context).deletePlayer(index);
          }, onAllDeleteTap: () {
            BlocProvider.of<KuGouBloc>(context).clearPlayerList();
          }, onCancelTap: () {
            Navigator.pop(context);
          }, onItemTap: (index) {
            BlocProvider.of<KuGouBloc>(context).playOfIndex(index);
          });
        });
  }

  Widget _buildPlayerList(
    BuildContext context, {
    VoidCallback onOrderTap,
    ValueChanged onItemTap,
    ValueChanged onItemDeleteTap,
    VoidCallback onAllDeleteTap,
    VoidCallback onCancelTap,
  }) {
    return StreamBuilder(
        initialData: PlaySongInfoBean(),
        stream: widget.playerStream,
        builder: (_, AsyncSnapshot<PlaySongInfoBean> snapshot) => Container(
              height: MediaQuery.of(context).size.height * 0.7,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      //compare_arrows
                      FlatButton.icon(
                          onPressed: onOrderTap,
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                          label: DefaultTextStyle(
                              style: TextStyle(color: Colors.black),
                              child: Text(
                                  "顺序播放(${BlocProvider.of<KuGouBloc>(context).playListInfo.plays.length})"))),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Material(
                        child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                            onPressed: onAllDeleteTap),
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                  Divider(
                    height: 1.0,
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: BlocProvider.of<KuGouBloc>(context)
                          .playListInfo
                          .plays
                          .length,
                      separatorBuilder: (_, _i) => Divider(
                            height: 1.0,
                            indent: 50.0,
                          ),
                      itemBuilder: (_, index) => _buildPlayerListItem(
                          index,
                          BlocProvider.of<KuGouBloc>(context).playListInfo,
                          onItemTap,
                          onItemDeleteTap),
                    ),
                  ),
                  Divider(
                    height: 1.0,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onCancelTap,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: DefaultTextStyle(
                          style: TextStyle(color: Colors.black),
                          child: Text(
                            "关闭",
                          )),
                    ),
                  )
                ],
              ),
            ));
  }

  Widget _buildPlayerListItem(
    int index,
    PlaySongListInfoBean bean,
    ValueChanged onItemTap,
    ValueChanged onItemDeleteTap,
  ) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          onItemTap(index);
        },
        child: Row(
          children: <Widget>[
            Container(
              width: 50.0,
              height: 50.0,
              alignment: Alignment.center,
              child: bean.index == index
                  ? CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(bean.plays[index].data.img),
                    )
                  : DefaultTextStyle(
                      style: TextStyle(color: Colors.black, fontSize: 12.0),
                      child: Text("${index < 9 ? "0" : ""}${index + 1}"),
                    ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTextStyle(
                    style: TextStyle(
                        color: index == bean.index
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                        fontSize: 14.0),
                    child: Text(bean.plays[index].data.song_name),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                        color: index == bean.index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        fontSize: 12.0),
                    child: Text(bean.plays[index].data.author_name),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onPressed: () {
                onItemDeleteTap(index);
              },
            )
          ],
        ),
      ),
    );
  }
}
