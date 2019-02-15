import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/view/kugou_banner.dart';

class Listen extends StatefulWidget {
  @override
  _ListenState createState() => _ListenState();
}

class _ListenState extends State<Listen> with AutomaticKeepAliveClientMixin {

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
                child: KuGouBanner(imageUrl: [
                  "https://imgessl.kugou.com/commendpic/20190109/20190109104215314555.jpg",
                  "https://imgessl.kugou.com/commendpic/20190109/20190109104155147376.jpg",
                  "https://imgessl.kugou.com/commendpic/20190108/20190108190956902072.jpg",
                  "https://imgessl.kugou.com/commendpic/20190214/20190214180525144797.jpg",
                ]),
              )
            ])),
            SliverGrid.count(
              crossAxisCount: 3,
              childAspectRatio: 1.3,
              children: <Widget>[
                Container(
                  color: Colors.red[100],
                ),
                Container(
                  color: Colors.red[200],
                ),
                Container(
                  color: Colors.red[300],
                ),
                Container(
                  color: Colors.red[400],
                ),
                Container(
                  color: Colors.red[500],
                ),
                Container(
                  color: Colors.red[600],
                ),
              ],
            ),
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

  @override
  bool get wantKeepAlive => true;
}
