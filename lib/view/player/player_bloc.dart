import 'dart:convert';

import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/component/bloc/kugou_bloc.dart';
import 'package:flutter_kugou/component/net/request_warehouse.dart';
import 'package:flutter_kugou/view/player/singer_images_bean.dart';
import 'package:flutter_kugou/view/player/song_info_bean.dart';
import 'dart:async';

class PlayerBloc extends BlocBase {
  KuGouBloc kuGouBloc;
  SongInfoBean _songInfo;

  StreamController<List<String>> _singerImagesController =
      StreamController.broadcast();

  Stream<List<String>> get singerStream => _singerImagesController.stream;

  PlayerBloc(this.kuGouBloc) {
    loadSingerImages();
    kuGouBloc.playStream.listen(_playSongListener);
  }

  void _playSongListener(PlaySongInfoBean playSongInfo) {
    // 监听是否换歌曲了
    if (playSongInfo.songInfo != _songInfo) {
      _songInfo = playSongInfo.songInfo;
      if (_songInfo != null)
        _getSingerImages();
      else
        _sendData([]);
    }
  }

  void loadSingerImages() {
    if (kuGouBloc.playerSongInfo.songInfo != null) {
      _songInfo = kuGouBloc.playerSongInfo.songInfo;
      _getSingerImages();
    }
  }

  void _getSingerImages() async {
    SingerImagesBean singerImages = await RequestWareHouse.instance()
        .getSingerImages(_songInfo.data.hash, _songInfo.data.song_name,
            _songInfo.data.author_name);
    _sendData(singerImages.data[0][0].imgs.imgs4
        .map((v) => v.sizable_portrait)
        .toList());
  }

  void _sendData(List<String> data) {
    if (!_singerImagesController.isClosed)
      _singerImagesController.add(data);
  }

  @override
  void dispose() {
    _singerImagesController.close();
  }
}
