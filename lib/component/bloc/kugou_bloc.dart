import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/bean/play_song_list_info_bean.dart';
import 'package:flutter_kugou/bean/song_info_bean.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:math';

class KuGouBloc extends BlocBase {
  VideoPlayerController _playerController;

  // 播放音乐的Stream
  StreamController<PlaySongInfoBean> _playerStreamController =
      StreamController.broadcast();
  Stream<PlaySongInfoBean> get playStream => _playerStreamController.stream;

  // 获取播放列表
  PlaySongListInfoBean get playListInfo => PlaySongListInfoBean(plays: _plays, index: _playIndex);

  // 获取现在播放的音乐学校
  SongInfoBean get playerInfo => ((_playIndex >= 0 && _playIndex < _plays.length) ? _plays[_playIndex] : null);

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

  void playOfIndex(int index) {
    if (index != _playIndex) {
      _playIndex = min(index, _plays.length - 1);
      _playNewSong();
    }
  }

  void deletePlayer(int index) {
    if (_plays.length <= 1) {
      clearPlayerList();
    } else {
      if (index == _playIndex) {
        _plays.removeAt(index);
        --_playIndex;
        playNext();
      } else {
        _plays.removeAt(index);
        if (index < _playIndex) {
          --_playIndex;
        }
      }
    }
  }

  void clearPlayerList() {
    _playIndex = -1;
    _plays.clear();
    if (_playerController != null) {
      _playerController.dispose();
      _playerController = null;
    }
    _sendStream(null);
  }

  void play() {
    if (_playerController != null) {
      _playerController.play();
      _sendStream(PlaySongInfoBean(
          songInfo: playerInfo,
          duration: _playerController.value.duration,
          position: _playerController.value.position,
          state: 1));
    } else {
      _sendStream(null);
    }
  }

  // 1为播放 0为暂停
  void pause() {
    if (_playerController != null) {
      _playerController.pause();
      _sendStream(PlaySongInfoBean(
          songInfo: playerInfo,
          duration: _playerController.value.duration,
          position: _playerController.value.position,
          state: 0));
    } else {
      _sendStream(null);
    }
  }

  void _playNewSong() {
    if (_playerController != null) {
      _playerController.dispose();
      _playerController = null;
    }
    _playerController =
    VideoPlayerController.network(playerInfo.data.play_url)
      ..initialize();
    _playerController.addListener(() {
      _sendStream(PlaySongInfoBean(
        songInfo: playerInfo,
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
