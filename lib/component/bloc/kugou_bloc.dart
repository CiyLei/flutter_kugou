import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/bean/play_song_list_info_bean.dart';
import 'package:flutter_kugou/bean/song_info_bean.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class KuGouBloc extends BlocBase {
  VideoPlayerController _playerController;

  StreamController<PlaySongInfoBean> _playerStreamController =
      StreamController.broadcast();
  Stream<PlaySongInfoBean> get playStream => _playerStreamController.stream;

  PlaySongListInfoBean get playListInfo => PlaySongListInfoBean(plays: _plays, index: _playIndex);

  List<SongInfoBean> _plays = [];
  int _playIndex = -1;

  void addAndPlay(SongInfoBean bean) {
    if (_plays.contains(bean))
      _playIndex = _plays.indexOf(bean);
    else
      _plays.insert(++_playIndex, bean);
    _playNewSong();
  }

  void add(SongInfoBean bean) {
    if (_plays.contains(bean)) _plays.remove(bean);
    _plays.insert((_playIndex + 1), bean);
//    _playNewSong();
  }

  void playNext() {
    if (_plays.length > 0) {
      ++_playIndex;
      if (_playIndex >= _plays.length) _playIndex = 0;
      _playNewSong();
    }
  }

  void play() {
    if (_playerController != null) {
      _playerController.play();
      _sendStream(PlaySongInfoBean(
          songInfo: _plays[_playIndex],
          duration: _playerController.value.duration,
          position: _playerController.value.position,
          state: 1));
    } else {
      _sendStream(null);
    }
  }

  void pause() {
    if (_playerController != null) {
      _playerController.pause();
      _sendStream(PlaySongInfoBean(
          songInfo: _plays[_playIndex],
          duration: _playerController.value.duration,
          position: _playerController.value.position,
          state: 0));
    } else {
      _sendStream(null);
    }
  }

  // 1为播放 0为暂停
  void _playNewSong() {
    if (_playerController != null) {
      _playerController.pause();
      _playerController.dispose();
    }
    _playerController =
        VideoPlayerController.network(_plays[_playIndex].data.play_url)
          ..initialize();
    _playerController.addListener(() {
      _sendStream(PlaySongInfoBean(
        songInfo: _plays[_playIndex],
        duration: _playerController.value.duration,
        position: _playerController.value.position,
      ));
    });
    _playerController.play();
  }

  void _sendStream(PlaySongInfoBean bean) {
    if (bean == null) {
      _playerStreamController.add(PlaySongInfoBean(state: 0));
    } else {
      _playerStreamController.add(bean);
    }
  }

  @override
  void dispose() {
    _playerStreamController.close();
  }
}
