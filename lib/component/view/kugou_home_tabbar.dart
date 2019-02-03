import 'package:flutter/material.dart';

class KuGouTabBarView extends StatefulWidget {

  KuGouTabBarView({this.controller, this.children});

  final TabController controller;
  final List<Widget> children;

  @override
  _KuGouTabBarViewState createState() => _KuGouTabBarViewState();
}

class _KuGouTabBarViewState extends State<KuGouTabBarView> {

  Offset _dowmPoint;
  bool tabbarOpenEnable, flag;

  @override
  void initState() {
    super.initState();
    tabbarOpenEnable = true;
    flag = true;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _dowmPoint = event.position;
      },
      onPointerMove: (PointerMoveEvent event) {
        if (flag && event.position.dx != _dowmPoint.dx && widget.controller.index == 0) {
          if (event.position.dx > _dowmPoint.dx) {
            setState(() {
              tabbarOpenEnable = false;
            });
          } else {
            setState(() {
              tabbarOpenEnable = true;
            });
          }
          flag = false;
        }
      },
      onPointerUp: (PointerUpEvent event) {
        flag = true;
        setState(() {});
      },
      child: AbsorbPointer(
        absorbing: widget.controller.index != 0 ? false : !tabbarOpenEnable,
        child: TabBarView(
          controller: widget.controller,
          children: widget.children,
        ),
      ),
    );
  }
}
