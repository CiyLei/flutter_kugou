import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/net/network_image.dart';

class KuGouBanner extends StatefulWidget {
  List<String> imageUrl;
  KuGouBannerController controller;

  KuGouBanner({this.imageUrl, this.controller, Key key}) : super(key: key);

  @override
  _KuGouBannerState createState() => _KuGouBannerState();
}

class _KuGouBannerState extends State<KuGouBanner> {
  double _pageContentWidth;
  ScrollController _scrollController;
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    widget.controller?._onNext = next;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pageContentWidth = MediaQuery.of(context).size.width * 0.85 + 20.0;
    if (_pageContentWidth > 0.0) {
      _scrollController = ScrollController(
          initialScrollOffset:
              (3 * _pageContentWidth - MediaQuery.of(context).size.width) / 2 +
                  (pageIndex - 1) * _pageContentWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 150.0,
          alignment: Alignment.center,
          child: Listener(
            onPointerUp: (PointerUpEvent event) {
              // 屏幕跟实际内容相差的部分
              double _diff = max(0, MediaQuery.of(context).size.width * 0.15 - 20);
              double _offset = _scrollController.offset + _diff;
              pageIndex = (_offset / _pageContentWidth + 0.5).toInt();
              toIndex(pageIndex);
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: _bildBannerItems(),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: 10.0,
          right: 10.0,
          child: _buildIndicator(),
        ),
      ],
    );
  }

  Future _sleepJumpTo(Duration duration, int index) async {
    await Future.delayed(duration);
    if (index == 0) {
      pageIndex = widget.imageUrl.length;
    } else if (index == widget.imageUrl.length + 1) {
      pageIndex = 1;
    }
    _scrollController.jumpTo(
        (3 * _pageContentWidth - MediaQuery.of(context).size.width) / 2 +
            (pageIndex - 1) * _pageContentWidth);
    setState(() {});
  }

  void next() {
    pageIndex++;
    if (pageIndex > widget.imageUrl.length + 1)
      pageIndex = 0;
    toIndex(pageIndex);
  }

  void toIndex(int index) {
    _scrollController.animateTo(
        (3 * _pageContentWidth - MediaQuery.of(context).size.width) / 2 +
            (index - 1) * _pageContentWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear);
    setState(() {});
    if (index == 0 || index == widget.imageUrl.length + 1) {
      _sleepJumpTo(const Duration(milliseconds: 300), index);
    }
  }

  List<Widget> _bildBannerItems() {
    List<Widget> items = [];
    items.add(_buildBannerItem(widget.imageUrl[widget.imageUrl.length - 1]));
    items.addAll(widget.imageUrl.map((v) => _buildBannerItem(v)));
    items.add(_buildBannerItem(widget.imageUrl[0]));
    return items;
  }

  Widget _buildBannerItem(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: MyNetworkImage(imageUrl), fit: BoxFit.fitHeight),
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(5.0), topEnd: Radius.circular(5.0))),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.imageUrl.length, (i) {
        return Container(
          height: 5.0,
          width: 5.0,
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
          decoration: BoxDecoration(
            color: i == pageIndex - 1 ? Colors.white : Colors.grey,
            shape: BoxShape.circle
          ),
        );
      }).toList(),
    );
  }
}

class KuGouBannerController {
  void Function() _onNext;
  void animationToNext() {
    if (_onNext != null) {
      _onNext();
    }
  }
}