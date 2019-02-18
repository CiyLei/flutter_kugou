import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/view/kugou_banner.dart';

class Listen extends StatefulWidget {
  @override
  _ListenState createState() => _ListenState();
}

class _ListenState extends State<Listen> with AutomaticKeepAliveClientMixin {
  KuGouBannerController _bannerController;
  Timer _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerController = KuGouBannerController();
    _bannerTimer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      _bannerController.animationToNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: KuGouBanner(controller: _bannerController, imageUrl: [
                  "https://imgessl.kugou.com/commendpic/20190109/20190109104215314555.jpg",
                  "https://imgessl.kugou.com/commendpic/20190109/20190109104155147376.jpg",
                  "https://imgessl.kugou.com/commendpic/20190108/20190108190956902072.jpg",
                  "https://imgessl.kugou.com/commendpic/20190214/20190214180525144797.jpg",
                ]),
              )
            ])),
            _buildMenuGrid(),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Container(
                height: 50.0,
                color: Colors.green,
              );
            }, childCount: 20))
          ],
        ),
      ],
    );
  }

  SliverGrid _buildMenuGrid() {
    return SliverGrid.count(
      crossAxisCount: 3,
      childAspectRatio: 1.8,
      children: <Widget>[
        _buildMenuItem(
            icon: Icons.music_note, color: Colors.orangeAccent, title: "乐库"),
        _buildMenuItem(
            icon: Icons.format_list_bulleted,
            color: Colors.greenAccent,
            title: "歌单"),
        _buildMenuItem(
            icon: Icons.swap_vert, color: Colors.blueAccent, title: "电台"),
        _buildMenuItem(
            icon: Icons.hdr_strong, color: Colors.purpleAccent, title: "猜你喜欢"),
        _buildMenuItem(
            icon: Icons.style, color: Colors.redAccent, title: "每日推荐"),
        _buildMenuItem(icon: Icons.cake, color: Colors.grey, title: "更多"),
      ],
    );
  }

  Widget _buildMenuItem(
      {@required IconData icon,
      @required Color color,
      @required String title}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 30.0,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30.0,
              ),
              backgroundColor: color,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(title)
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    _bannerTimer.cancel();
  }

  @override
  bool get wantKeepAlive => true;
}
