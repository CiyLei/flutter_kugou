import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:meta/meta.dart';

class LyricManager {
  List<Lyric> _lyrics = [];
  List<Lyric> get lyricList => _lyrics;

  String lyrics;
  Duration duration;

  static Map<String, LyricManager> _cache = {};

  factory LyricManager.PlaySongInfoBean(PlaySongInfoBean data) {
    if (data == null || data.songInfo == null)
      return null;
    if (!_cache.containsKey(data.songInfo.data.hash))
      _cache[data.songInfo.data.hash] = LyricManager(
          lyrics: data.songInfo.data.lyrics.trim(), duration: data.duration);
    return _cache[data.songInfo.data.hash];
  }

  LyricManager({@required this.lyrics, @required this.duration})
      : assert(lyrics != null && duration != null) {
    bool isLyricTime = true;
    String lyricTime = "";
    String lyricContent = "";
    for (int i = 0; i < lyrics.length; i++) {
      if (lyrics[i] == "[") {
        if (lyricTime.isNotEmpty) {
          _lyrics.add(Lyric(content: lyricContent, duration: lyricTime));
          lyricTime = "";
          lyricContent = "";
        }
        isLyricTime = true;
        continue;
      } else if (lyrics[i] == "]") {
        isLyricTime = false;
        continue;
      }

      if (isLyricTime) {
        lyricTime += lyrics[i];
      } else {
        lyricContent += lyrics[i];
      }
    }
    _lyrics.add(Lyric(content: lyricContent, duration: lyricTime));
    for (int i = 0; i < _lyrics.length; i++) {
      if (i == _lyrics.length - 1) {
        _lyrics[i].keepTime = duration - _lyrics[i].time;
      } else {
        _lyrics[i].keepTime = _lyrics[i + 1].time - _lyrics[i].time;
      }
    }
  }

  int getIndexOfPosition(Duration position) {
    for(int i = 0; i < _lyrics.length; i++) {
      if (position >= _lyrics[i].time && position <= _lyrics[i].time + _lyrics[i].keepTime)
        return i;
    }
    return 0;
  }

  Lyric getLyricOfPosition(Duration position) {
    if (_lyrics.length > 0)
      return this.lyricList[getIndexOfPosition(position)];
    return null;
  }

  @override
  String toString() {
    return _lyrics.toString();
  }
}

class Lyric {
  String content;
  Duration time;
  Duration keepTime;

  Lyric({this.content, String duration}) {
    var matches = RegExp(r"^(\d+?):(\d+?)\.(\d+)$").allMatches(duration).toList();
    if (matches.isNotEmpty && matches[0].groupCount == 3) {
      List<int> times = [
        matches[0].group(1),
        matches[0].group(2),
        matches[0].group(3)
      ].map((v) => int.parse(v)).toList();
      time = Duration(
          minutes: times[0], seconds: times[1], milliseconds: times[2] * 10);
    } else {
      time = Duration();
    }
  }


  @override
  bool operator ==(other) {
    if (other is Lyric)
      return content == other.content && time == other.time;
    return false;
  }

  @override
  String toString() {
    return "content:${content.toString()},time:${time.toString()},keepTime:${keepTime.toString()}\n";
  }
}
