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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        collectionFlag = true;
        downPoint = event.position;
        moveDraw = false;
      },
      onPointerMove: (PointerMoveEvent event) {
        if (collectionFlag && event.position.dx > downPoint.dx && widget.controller.index == 0) {
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
        physics: moveDraw ? NeverScrollableScrollPhysics() : null,
        controller: widget.controller,
        children: widget.children,
      ),
    );
  }
}

class KuGouTabBarViewScrollerNotification extends Notification {

  double dx;

  KuGouTabBarViewScrollerNotification(this.dx);

}