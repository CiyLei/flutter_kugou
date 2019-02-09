import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kugou/component/net/network_image.dart';
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
  static const _imagePalettePlatform = const MethodChannel('com.ciy.flutterkugou/imagePalette');

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
    if (_songImageIndex < widget.singImages.length) {
      _imagePalette(widget.singImages[_songImageIndex]);
      return _songImageIndex;
    }
    return 0;
  }

  int _getNextIndex() {
    if (_songImageIndex + 1 < widget.singImages.length)
      return _songImageIndex + 1;
    return 0;
  }

  // 用异步去取图片的主色调会让界面严重卡顿，放到另一个Ioslate中又不起作用，不知道为什么，所以放到native层去做
  void _imagePalette(String url) async{
    if (Platform.isAndroid || Platform.isIOS) {
      String colorStr = await _imagePalettePlatform.invokeMethod("getImagePalette", url);
      List<String> colors = colorStr.split(",");
      if (colors.length == 4) {
        Color c = Color.fromARGB(int.parse(colors[0]), int.parse(colors[1]), int.parse(colors[2]), int.parse(colors[3]));
        if (widget.controller != null && widget.controller.onPaletteChange != null)
          widget.controller.onPaletteChange(c);
      }
    } else {
      Color paletteColor = await _getImagePaletteColor(MyNetworkImage(url));
      if (widget.controller != null && widget.controller.onPaletteChange != null && paletteColor != null)
        widget.controller.onPaletteChange(paletteColor);
    }
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
