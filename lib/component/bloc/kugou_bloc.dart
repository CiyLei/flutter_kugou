import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/bean/play_song_list_info_bean.dart';
import 'package:flutter_kugou/view/player/song_info_bean.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:audioplayer/audioplayer.dart';
import 'dart:async';
import 'dart:math';

// SongInfoBean只有歌曲信息  PlaySongInfoBean记录了不止歌曲信息，还有播放状态信息
class KuGouBloc extends BlocBase {

  // 播放音乐的Stream
  StreamController<PlaySongInfoBean> _playerStreamController =
      StreamController.broadcast();
  Stream<PlaySongInfoBean> get playStream => _playerStreamController.stream;

  // 获取播放列表
  PlaySongListInfoBean get playListInfo => PlaySongListInfoBean(plays: _plays, index: _playIndex);

  // 获取现在播放的音乐信息
  SongInfoBean get _songInfo => ((_playIndex >= 0 && _playIndex < _plays.length) ? _plays[_playIndex] : null);
  PlaySongInfoBean get playerSongInfo => _songInfo != null ? PlaySongInfoBean(
    songInfo: _songInfo,
    duration: _audioPlugin.duration,
    position: _currentDuration,
    state: _audioPlugin.state == AudioPlayerState.PLAYING ? 1 : 0
  ) : PlaySongInfoBean();

  AudioPlayer _audioPlugin = new AudioPlayer();
  Duration _currentDuration = Duration.zero;

  List<SongInfoBean> _plays = [];
  int _playIndex = -1;

  KuGouBloc() {
    _audioPlugin.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.COMPLETED && _plays.length > 0)
        playNext();
      else if(state == AudioPlayerState.PAUSED)
        pause(audioPluginPause: false);
    });
  }

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
    _currentDuration = Duration.zero;
    _audioPlugin.stop();
    _sendStream(null);
  }

  void play() {
    if (_playIndex >= 0 && _playIndex < _plays.length) {
      _audioPlugin.play(_songInfo.data.play_url);
      _sendStream(PlaySongInfoBean(
          songInfo: _songInfo,
          duration: _audioPlugin.duration,
          position: _currentDuration,
          state: 1));
    } else {
      _sendStream(null);
    }
  }

  // 1为播放 0为暂停
  void pause({audioPluginPause = true}) {
    if (_playIndex >= 0 && _playIndex < _plays.length) {
      if (audioPluginPause)
        _audioPlugin.pause();
      _sendStream(PlaySongInfoBean(
          songInfo: _songInfo,
          duration: _audioPlugin.duration,
          position: _currentDuration,
          state: 0));
    } else {
      _sendStream(null);
    }
  }

  void _playNewSong() {
    _audioPlugin.stop();
    _audioPlugin.onAudioPositionChanged.listen((duration) {
      _currentDuration = duration;
      _sendStream(PlaySongInfoBean(
        songInfo: _songInfo,
        duration: _audioPlugin.duration,
        position: duration,
      ));
    });
    _audioPlugin.play(_songInfo.data.play_url);
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
