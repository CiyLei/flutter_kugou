import 'package:meta/meta.dart';
import 'package:flutter_kugou/view/player/song_info_bean.dart';

class PlaySongInfoBean {
  SongInfoBean songInfo;

  // 总时间长
  Duration duration;

  // 当前时间
  Duration position;

  // 1为播放 0为暂停
  int state;

  PlaySongInfoBean(
      {this.songInfo,
      this.duration = const Duration(seconds: 0),
      this.position = const Duration(seconds: 0),
      this.state = 1});
}
