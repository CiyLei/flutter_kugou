import 'package:meta/meta.dart';
import 'package:flutter_kugou/bean/song_info_bean.dart';

class PlaySongInfoBean {
  SongInfoBean songInfo;

  // 总时间长
  Duration duration;

  // 当前时间
  Duration position;

  // 1为播放 0为暂停
  int state;

  PlaySongInfoBean(
      {@required this.songInfo,
      @required this.duration,
      @required this.position,
      this.state = 1});
}
