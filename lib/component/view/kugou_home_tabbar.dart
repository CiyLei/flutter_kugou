import 'package:flutter/material.dart';

class KuGouTabBarView extends StatefulWidget {

  KuGouTabBarView({this.controller, this.children});

  final TabController controller;
  final List<Widget> children;

  @override
  _KuGouTabBarViewState createState() => _KuGouTabBarViewState();
}

class _KuGouTabBarViewState extends State<KuGouTabBarView> {

  bool tabbarOpenEnable;

  @override
  void initState() {
    super.initState();
    tabbarOpenEnable = true;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        setState(() {
          if (event.position.dx <= MediaQuery.of(context).size.width / 3 && widget.controller.index == 0) {
            tabbarOpenEnable = false;
          } else {
            tabbarOpenEnable = true;
          }
        });
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
