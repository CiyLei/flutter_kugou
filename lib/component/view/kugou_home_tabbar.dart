import 'package:flutter/material.dart';

class KuGouTabBarView extends StatefulWidget {

  KuGouTabBarView({this.controller, this.children});

  final TabController controller;
  final List<Widget> children;

  @override
  _KuGouTabBarViewState createState() => _KuGouTabBarViewState();
}

class _KuGouTabBarViewState extends State<KuGouTabBarView> {

  Offset downPoint;
  bool collectionFlag = true;
  bool moveDraw = false;
  // 是否有滑动冲突
  bool scrollerNoConflict = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        scrollerNoConflict = notification.depth == 0 && widget.controller.index == 0;
        return true;
      },
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          collectionFlag = true;
          downPoint = event.position;
          moveDraw = false;
        },
        onPointerMove: (PointerMoveEvent event) {
          if (collectionFlag && event.position.dx > downPoint.dx && widget.controller.index == 0 && scrollerNoConflict) {
            setState(() {
              moveDraw = true;
            });
            collectionFlag = false;
          }
          if (moveDraw ) {
            KuGouTabBarViewScrollerNotification(event.delta.dx).dispatch(context);
          }
        },
        onPointerUp: (PointerUpEvent event) {
          setState(() {
            moveDraw = false;
          });
        },
        child: TabBarView(
          physics: moveDraw ? NeverScrollableScrollPhysics() : ScrollPhysics(),
          controller: widget.controller,
          children: widget.children,
        ),
      ),
    );
  }
}

// 为什么不用ScrollerNotification 因为在Scaffold之外就接收不到了，不知道哪里被拦截了
class KuGouTabBarViewScrollerNotification extends Notification {

  double dx;

  KuGouTabBarViewScrollerNotification(this.dx);

}