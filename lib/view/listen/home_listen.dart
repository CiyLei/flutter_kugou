import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/component/view/kugou_banner.dart';
import 'package:flutter_kugou/view/home_page_bloc.dart';

class Listen extends StatefulWidget {
  @override
  _ListenState createState() => _ListenState();
}

class _ListenState extends State<Listen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  ScrollController _customScrollController;
  KuGouBannerController _bannerController;
  Timer _bannerTimer;
  HomePageBloc _homePageBloc;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _bannerController = KuGouBannerController();
    _bannerTimer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      _bannerController.animationToNext();
    });
    _homePageBloc = BlocProvider.of<HomePageBloc>(context);
    _customScrollController = ScrollController();
    _customScrollController.addListener(() {
      if (_homePageBloc.searchIsExpand && _customScrollController.offset > 420.0) {
        _homePageBloc.closeSearch();
        setState(() {});
      } else if (!_homePageBloc.searchIsExpand && _customScrollController.offset < 420.0) {
        _homePageBloc.expandSearch();
        setState(() {});
      }
    });
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: CustomScrollView(
        controller: _customScrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 50.0),
              color: Theme.of(context).primaryColor,
              child: KuGouBanner(controller: _bannerController, imageUrl: [
                "https://imgessl.kugou.com/commendpic/20190109/20190109104215314555.jpg",
                "https://imgessl.kugou.com/commendpic/20190109/20190109104155147376.jpg",
                "https://imgessl.kugou.com/commendpic/20190108/20190108190956902072.jpg",
                "https://imgessl.kugou.com/commendpic/20190214/20190214180525144797.jpg",
              ]),
            ),
          ),
          _buildMenuGrid(),
          SliverPersistentHeader(
            delegate: KuGouHeaderDelegate(
                height: 40.0,
                child: _buildListTitle()
            ),
            pinned: true,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Container(
                      height: 50.0,
                      color: Colors.green[(index % 9 + 1) * 100],
                    );
                  }, childCount: 30))
        ],
      ),
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

  Widget _buildListTitle() {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(color: Colors.white),
      child: TabBar(
        isScrollable: true,
        indicatorPadding: const EdgeInsets.only(left: 25.0, right: 25.0),
        controller: _tabController,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: [
          _buildListTitleItem("新歌"),
          _buildListTitleItem("直播"),
          _buildListTitleItem("歌单"),
          _buildListTitleItem("资讯"),
          _buildListTitleItem("视频"),
        ],
      ),
    );
  }

  Widget _buildListTitleItem(String title) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.black),
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

class KuGouHeaderDelegate extends SliverPersistentHeaderDelegate {
  double height;
  Widget child;

  KuGouHeaderDelegate({@required this.height, @required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}
