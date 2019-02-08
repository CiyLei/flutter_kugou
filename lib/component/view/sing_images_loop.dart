import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/net/network_image.dart';
import 'package:flutter_kugou/component/palette_util.dart';
import 'package:palette_generator/palette_generator.dart';

class SingImagesLoopView extends StatefulWidget {
  List<String> singImages;
  Duration loopTime;
  SingImagesLoopController controller;

  SingImagesLoopView(this.singImages,
      {this.loopTime = const Duration(seconds: 15), this.controller}) {
    if (singImages == null) singImages = [];
  }

  @override
  _SingImagesLoopViewState createState() => _SingImagesLoopViewState();
}

class _SingImagesLoopViewState extends State<SingImagesLoopView>
    with SingleTickerProviderStateMixin {
  int _songImageIndex = 0;
  AnimationController _hideController;
  PaletteUtil _paletteUtil;

  @override
  void initState() {
    super.initState();
    _paletteUtil = PaletteUtil();
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
    if (_songImageIndex < widget.singImages.length) {
      _imagePalette(MyNetworkImage(widget.singImages[_songImageIndex]));
      return _songImageIndex;
    }
    return 0;
  }

  int _getNextIndex() {
    if (_songImageIndex + 1 < widget.singImages.length)
      return _songImageIndex + 1;
    return 0;
  }

  _imagePalette(ImageProvider imageProvider) async{
//    Color paletteColor = await _getImagePaletteColor(imageProvider);
    Color paletteColor = await _paletteUtil.sendImageProvider(imageProvider);
    if (widget.controller != null && widget.controller.onPaletteChange != null && paletteColor != null)
      widget.controller.onPaletteChange(paletteColor);
  }

  // 获取图片主色调
  Future<Color> _getImagePaletteColor(ImageProvider imageProvider) async {
    if (!_paletteCache.containsKey(imageProvider)){
      PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
      int num = 0; // 因为有可能失败，所以再给他3次机会
      while((paletteGenerator.dominantColor == null || paletteGenerator.dominantColor.color == null) && num < 3) {
        num++;
        paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
      }
      _paletteCache[imageProvider] = paletteGenerator.dominantColor?.color;
    }
    return _paletteCache[imageProvider];
  }

  Map<ImageProvider, Color> _paletteCache = {};

  @override
  Widget build(BuildContext context) {
    return widget.singImages.length == 0
        ? Container(
            color: Theme.of(context).primaryColor,
          )
        : Container(
            foregroundDecoration: BoxDecoration(color: Colors.black38),
            child: Stack(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor)),
                Image(
                  image: MyNetworkImage(widget.singImages[_getIndex()]),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                AnimatedBuilder(
                    animation: _hideController,
                    builder: (_c, _c2) => Opacity(
                          opacity: _hideController.value,
                          child: Image(
                            image: MyNetworkImage(widget.singImages[_getNextIndex()]),
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ))
              ],
            ),
          );
  }

  @override
  void dispose() {
    _hideController.dispose();
    _hideController = null;
    _paletteUtil.close();
    super.dispose();
  }
}

class SingImagesLoopController {
  // 1播放， 0暂停
  bool isLoop;
  VoidCallback _onStartListener;
  ValueChanged<Color> onPaletteChange;

  set listener(VoidCallback val) => _onStartListener = val;

  SingImagesLoopController({this.isLoop = true, this.onPaletteChange});

  void loop() {
    isLoop = true;
    if (_onStartListener != null) _onStartListener();
  }

  void pause() {
    isLoop = false;
  }
}
