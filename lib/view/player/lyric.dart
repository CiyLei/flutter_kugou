import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/view/player/lyric_manager.dart';

// LyricsView没办法保存状态，如果判断是否到下一句只能写在_LyricsWidgetState里面了(不优雅)
class LyricsWidget extends StatefulWidget {
  PlaySongInfoBean data;

  LyricsWidget(this.data);

  @override
  _LyricsWidgetState createState() => _LyricsWidgetState();
}

class _LyricsWidgetState extends State<LyricsWidget> with SingleTickerProviderStateMixin{

  int _previousIndex;
  AnimationController _moveController;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null || widget.data.songInfo == null)
      return SizedBox();
    LyricManager manager = LyricManager.PlaySongInfoBean(widget.data);
    if (_previousIndex == null || _previousIndex == manager.getIndexOfPosition(widget.data.position) - 1){
      if (_previousIndex != null) {
        _moveController.reset();
        _moveController.forward();
      }
      _previousIndex = manager.getIndexOfPosition(widget.data.position);
    } else if (_previousIndex != manager.getIndexOfPosition(widget.data.position))
      _previousIndex = null;
    return AnimatedBuilder(animation: _moveController, builder: (c, _) => CustomPaint(
      size: Size.infinite,
      painter: LyricsView(
          manager: manager,
          position: widget.data.position,
          moveOffset: 1.0 - _moveController.value
      ),
    ));
  }
}

class LyricsView extends CustomPainter {
  LyricManager manager;
  Duration position;

  // 上下各多少行
  int ladderNum;
  // 每个阶级相差多少
  double ladderDiff = 10;
  Color mainColor;
  Color minorColor;

  double moveOffset = 0.0;

  LyricsView(
      {this.manager,
      this.position,
        this.moveOffset = 0.0,
      this.mainColor = Colors.orangeAccent,
      this.minorColor = Colors.white,
      this.ladderDiff = 10.0,
      this.ladderNum = 5});

  @override
  void paint(Canvas canvas, Size size) {
    _drawLyric(size, canvas);
  }

  // 保证每个阶级相差的总和不超出屏幕大小
  double diff(double sizeHeight,double textHeight) => min(ladderDiff, sizeHeight / (ladderNum * 2 + 1) - textHeight);

  void _drawLyric(Size size, Canvas canvas) {
    int index = manager.getIndexOfPosition(position);
    for (int i = index - ladderNum; i <= index + ladderNum; i++) {
      if (i >= 0 && i < manager.lyricList.length) {
        double ladderProgress = (i - index).abs() / ladderNum;
        TextPainter text = getTextPainter(manager.lyricList[i]?.content, 0.3 + (1.0 - ladderProgress) * 0.7);
        double startLeft = (size.width - text.width) / 2;
        double startTop = (size.height - text.height) / 2;
        // 如果绘制的是当前歌词
        if (i == index) {
          Lyric lyric = manager.getLyricOfPosition(position);
          double progress = (position - lyric.time).inMilliseconds /
              lyric.keepTime.inMilliseconds;
          text = getTextPainter(manager.lyricList[i]?.content, 1,
              progress: progress, startLeft: startLeft, startTop: startTop);
        }
        text.paint(canvas,
            Offset(startLeft, startTop + (diff(size.height, text.height) + text.height) * (i - index + moveOffset)));
      }
    }
  }

  TextPainter getTextPainter(String text, double opacity,
      {double progress, double startLeft, double startTop}) {
    TextPainter painter = TextPainter(
      text: TextSpan(
          style: TextStyle(fontSize: 18.0, color: Color.fromRGBO(minorColor.red, minorColor.green, minorColor.blue, opacity)), text: text),
      textDirection: TextDirection.ltr,
    )..layout();
    if (progress != null && startLeft != null && startTop != null) {
      final fullRect =
          new Rect.fromLTWH(startLeft, startTop, painter.width, painter.height);
      final gradient = new LinearGradient(
        colors: List.generate(100, (i) {
          if (i < progress * 100) return mainColor;
          return minorColor;
        }),
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      final gradientPaint = new Paint()
        ..shader = gradient.createShader(fullRect);
      return TextPainter(
        text: TextSpan(
            style: TextStyle(fontSize: 18.0, foreground: gradientPaint),
            text: text),
        textDirection: TextDirection.ltr,
      )..layout();
    }
    return painter;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
