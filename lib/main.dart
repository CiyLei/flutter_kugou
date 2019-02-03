import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/view/kugou_bottom_navigation.dart';
import 'package:flutter_kugou/component/view/kugou_drawer.dart';
import 'package:flutter_kugou/view//home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      title: "酷狗",
      home: KuGouApp(),
    );
  }
}

class KuGouApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KuGouAppState();
  }
}

class _KuGouAppState extends State<KuGouApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KuGouScaffold(
      drawer: KuGouDrawer(),
      child: Stack(
        children: <Widget>[
          HomePage(),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: KuGouBottomNavigation(
                imgUrl:
                    "http://imge.kugou.com/stdmusic/20161229/20161229233400375274.jpg",
                song: "光年之外",
                author: "G.E.M.邓紫棋",),
          )
        ],
      ),
    );
//    return Scaffold(
//      drawer: KuGouDrawer(),
//      body: Stack(
//        children: <Widget>[
//          HomePage(),
//          Positioned(
//            bottom: 0.0,
//            left: 0.0,
//            right: 0.0,
//            child: KuGouBottomNavigation(
//                imgUrl:
//                    "http://imge.kugou.com/stdmusic/20161229/20161229233400375274.jpg",
//                song: "光年之外",
//                author: "G.E.M.邓紫棋",),
//          )
//        ],
//      ),
//    );
  }
}
