import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/component/base_state.dart';
import 'package:flutter_kugou/component/utils/view.dart';
import 'package:flutter_kugou/component/view/sing_images_loop.dart';
import 'package:flutter_kugou/view/player/lyric.dart';
import 'package:flutter_kugou/view/player/player_bloc.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends BaseState<Player, PlayerBloc> {
  SingImagesLoopController _loopController;
  Color mainColor;

  @override
  void initState() {
    super.initState();
    _loopController = SingImagesLoopController();
    _loopController.onPaletteChange = (Color c) {
      if (c.value != mainColor.value) {
        setState(() {
          mainColor = c;
        });
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mainColor = Theme.of(context).primaryColor;
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
              controller: _loopController,
            );
          },
        ),
        StreamBuilder(
          initialData: bloc.kuGouBloc.playerSongInfo,
          stream: bloc.kuGouBloc.playStream,
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
              body: _buildBody(snapshot.data),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(PlaySongInfoBean data) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            data.songInfo?.data?.author_name ?? "",
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        ),
        Expanded(
          child: Center(
            child: LyricsWidget(data),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          alignment: Alignment.center,
          height: 20.0,
          child: _buildProgress(data.position, data.duration),
        ),
        Container(
          alignment: Alignment.center,
          height: 80.0,
          child: _buildPlayerButtons(
              state: data.state,
              onOrderTap: () {},
              onListTap: () {
                ViewUtils.showPlayerList(context, bloc.kuGouBloc);
              },
              onPlayerTap: () {
                if (data.state == 0)
                  bloc.kuGouBloc.play();
                else
                  bloc.kuGouBloc.pause();
              },
              onNextTap: () {
                bloc.kuGouBloc.playNext();
              },
              onPreviousTap: () {
                bloc.kuGouBloc.playPrevious();
              }),
        ),
      ],
    );
  }

  // state 1为播放 0为暂停
  Widget _buildPlayerButtons(
      {int state,
      GestureTapCallback onPlayerTap,
      GestureTapCallback onPreviousTap,
      GestureTapCallback onNextTap,
      GestureTapCallback onOrderTap,
      GestureTapCallback onListTap}) {
    return Row(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onOrderTap,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                color: mainColor,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: onPreviousTap,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Material(
                color: mainColor,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: onPlayerTap,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      state == 0 ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Material(
                color: mainColor,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: onNextTap,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onListTap,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Icon(
                Icons.playlist_play,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgress(Duration position, Duration duration) {
    return Row(
      children: <Widget>[
        Text(
          "${position.inSeconds ~/ 60}:${position.inSeconds % 60 < 10 ? "0" : ""}${position.inSeconds % 60}",
          style: TextStyle(color: Colors.white, fontSize: 10.0),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: mainColor,
              inactiveTrackColor: Colors.grey,
              thumbColor: Colors.white,
              activeTickMarkColor: mainColor,
              inactiveTickMarkColor: Colors.grey,
            ),
            child: Slider(
              onChanged: (v) {
                bloc.kuGouBloc.seek(v);
              },
              value: position.inSeconds.toDouble(),
              min: 0,
              max: duration.inSeconds.toDouble(),
              divisions: 100,
            ),
          ),
        ),
        Text(
          "${duration.inSeconds ~/ 60}:${duration.inSeconds % 60 < 10 ? "0" : ""}${duration.inSeconds % 60}",
          style: TextStyle(color: Colors.white, fontSize: 10.0),
        ),
      ],
    );
  }
}
