// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kugou/main.dart';

void main() {
//  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(KuGouApp());
//
//    // Verify that our counter starts at 0.
//    expect(find.text('0'), findsOneWidget);
//    expect(find.text('1'), findsNothing);
//
//    // Tap the '+' icon and trigger a frame.
//    await tester.tap(find.byIcon(Icons.add));
//    await tester.pump();
//
//    // Verify that our counter has incremented.
//    expect(find.text('0'), findsNothing);
//    expect(find.text('1'), findsOneWidget);
//  });
  LyricManager manager = LyricManager(lyrics: "[00:00.00]G.E.M.邓紫棋-光年之外[00:01.66]作词：邓紫棋[00:02.89]作曲：邓紫棋[00:12.73]感受停在我[00:13.93]发端的指尖[00:16.69]如何瞬间冻结时间[00:23.48]记住望着我[00:25.11]坚定的双眼[00:27.46]也许已经没有明天[00:33.96]面对浩瀚的星海[00:36.54]我们微小得像尘埃[00:39.21]漂浮在一片无奈[00:44.89]缘分让我们[00:46.47]相遇乱世以外[00:50.12]命运却要我们[00:52.27]危难中相爱[00:55.55]也许未来遥远在[00:58.26]光年之外[01:01.37]我愿守候未知里[01:03.77]为你等待[01:05.53]我没想到为了你[01:07.37]我能疯狂到[01:10.78]山崩海啸没有你[01:12.78]根本不想逃[01:16.21]我的大脑为了你[01:18.36]已经疯狂到[01:21.67]脉搏心跳没有你[01:23.71]根本不重要[01:28.98]一双围在我[01:30.46]胸口的臂弯[01:33.08]足够抵挡天旋地转[01:39.83]一种执迷[01:41.06]不放手的倔强[01:43.76]足以点燃所有希望[01:50.29]宇宙磅礴而冷漠[01:52.89]我们的爱[01:53.81]微小却闪烁[01:55.52]颠簸却如此忘我[02:01.22]缘分让我们[02:02.81]相遇乱世以外[02:06.68]命运却要我们[02:08.73]危难中相爱[02:12.08]也许未来遥远在[02:14.74]光年之外[02:17.66]我愿守候未知里[02:20.13]为你等待[02:21.77]我没想到为了你[02:23.91]我能疯狂到[02:27.22]山崩海啸没有你[02:29.20]根本不想逃[02:32.62]我的大脑为了你[02:34.72]已经疯狂到[02:37.93]脉搏心跳没有你[02:40.12]根本不重要[02:44.06]也许航道以外[02:49.74]是醒不来的梦[02:56.64]乱世以外[03:00.42]是纯粹的相拥[03:05.45]我没想到为了你[03:07.55]我能疯狂到[03:10.87]山崩海啸没有你[03:12.85]根本不想逃[03:16.18]我的大脑为了你[03:18.37]已经疯狂到[03:21.75]脉搏心跳没有你[03:24.13]根本不重要[03:28.02]相遇乱世以外[03:33.48]危难中相爱[03:38.61]相遇乱世以外[03:43.54]危难中相爱[03:48.97]我没想到",
      duration: Duration(milliseconds: 235000));
  print(manager);
  print("----------");
  print(manager.lyricList[manager.getIndexOfPosition(const Duration(seconds: 197))]);
}

class LyricManager {
  List<Lyric> _lyrics = [];
  List<Lyric> get lyricList => _lyrics;

  String lyrics;
  Duration duration;

  LyricManager({@required this.lyrics, @required this.duration}) : assert(lyrics != null && duration != null) {
    bool isLyricTime = true;
    String lyricTime = "";
    String lyricContent = "";
    for(int i = 0; i < lyrics.length; i++) {
      if (lyrics[i] == "[") {
        if (lyricTime.isNotEmpty) {
          _lyrics.add(Lyric(content: lyricContent, duration: lyricTime));
          lyricTime = "";
          lyricContent = "";
        }
        isLyricTime = true;
        continue;
      }
      else if (lyrics[i] == "]"){
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
    List<int> times = [duration.substring(0, 2), duration.substring(3, 5), duration.substring(6, 8)].map((v) => int.parse(v)).toList();
    time = Duration(minutes: times[0], seconds: times[1], milliseconds: times[2] * 10);
  }

  @override
  String toString() {
    return "content:${content.toString()},time:${time.toString()},keepTime:${keepTime.toString()}\n";
  }

}
