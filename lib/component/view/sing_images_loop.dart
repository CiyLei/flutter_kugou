import 'package:flutter/material.dart';

class SingImagesLoopView extends StatefulWidget {
  List<String> singImages;
  Duration loopTime;
  SingImagesLoopController controller;

  SingImagesLoopView(this.singImages,
      {this.loopTime = const Duration(seconds: 5), this.controller}) {
    if (singImages == null) singImages = [];
  }

  @override
  _SingImagesLoopViewState createState() => _SingImagesLoopViewState();
}

class _SingImagesLoopViewState extends State<SingImagesLoopView>
    with SingleTickerProviderStateMixin {
  int _songImageIndex = 0;
  AnimationController _hideController;

  @override
  void initState() {
    super.initState();
    _hideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _hideController.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        if (widget.controller.isLoop) {
          setState(() {
            _songImageIndex = _getNextIndex();
            _hideController.reset();
            _start();
          });
        }
      }
    });
    widget.controller.listener = () {
      _start();
    };
    _start();
  }

  @override
  void didUpdateWidget(SingImagesLoopView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.singImages.isEmpty && widget.singImages.isNotEmpty) {
      _start();
    }
  }

  void _start() async {
    if (widget.controller.isLoop &&
        _hideController != null &&
        widget.singImages.length > 0) await Future.delayed(widget.loopTime);
    if (widget.controller.isLoop &&
        _hideController != null &&
        widget.singImages.length > 0) _hideController.forward();
  }

  int _getIndex() {
    if (_songImageIndex < widget.singImages.length) return _songImageIndex;
    return 0;
  }

  int _getNextIndex() {
    if (_songImageIndex + 1 < widget.singImages.length)
      return _songImageIndex + 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return widget.singImages.length == 0
        ? Container(
            color: Theme.of(context).primaryColor,
          )
        : Stack(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor)),
              Image.network(
                widget.singImages[_getIndex()],
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              AnimatedBuilder(
                  animation: _hideController,
                  builder: (_c, _c2) => Opacity(
                        opacity: _hideController.value,
                        child: Image.network(
                          widget.singImages[_getNextIndex()],
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ))
            ],
          );
  }

  @override
  void dispose() {
    _hideController.dispose();
    _hideController = null;
    super.dispose();
  }
}

class SingImagesLoopController {
  // 1播放， 0暂停
  bool isLoop;
  VoidCallback _onStartListener;

  set listener(VoidCallback val) => _onStartListener = val;

  SingImagesLoopController({this.isLoop = true});

  void loop() {
    isLoop = true;
    if (_onStartListener != null) _onStartListener();
  }

  void pause() {
    isLoop = false;
  }
}
