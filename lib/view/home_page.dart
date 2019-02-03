import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/component/view/kugou_drawer.dart';
import 'package:flutter_kugou/component/view/kugou_home_tabbar.dart';
import 'package:flutter_kugou/view//me/home_me.dart';
import 'package:flutter_kugou/view/home_page_bloc.dart';
import 'package:flutter_kugou/view/listen/home_listen.dart';
import 'package:flutter_kugou/view/look/home_look.dart';
import 'package:flutter_kugou/view/sing/home_sing.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, TickerProviderStateMixin {
  int _currentIndex;
  TabController _tabController;
  final _titleList = ["我", "听", "看", "唱"];
  HomePageBloc _bloc;
  AnimationController _searchHeightController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      _changeNavigationTitle(_tabController.index);
    });

    _bloc = BlocProvider.of<HomePageBloc>(context);
    _bloc.searchHeightStream.listen((val) {
      _searchHeightController.animateTo(val);
    });

    _searchHeightController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300), lowerBound: 0.0, upperBound: 50.0);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  _changeNavigationTitle(int index) {
    setState(() {
      if (_currentIndex != index) {
        _currentIndex = index;
        _tabController.animateTo(index);
        if (!_bloc.searchIsExpand)
          _bloc.expandSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavigationBar(context),
      body: DecoratedBox(
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .primaryColor
        ),
        child: Stack(
          children: <Widget>[
            KuGouTabBarView(
              controller: _tabController,
              children: [Me(), Listen(), Look(), Sing()],
            ),
            _buildSearch(context, "SING女团 团团圆圆"),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch(BuildContext context, String search) {
    return AnimatedBuilder(
        animation: _searchHeightController, builder: (buildContext, child) {
      return Transform.translate(
        offset: Offset(0.0, -_searchHeightController.value),
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          padding: const EdgeInsets.only(bottom: 5.0, left: 15.0, right: 15.0),
          color: Theme
              .of(context)
              .primaryColor,
          child: Container(
            height: 30.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              color: Colors.white24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.search,
                  size: 14.0,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  search,
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      border: Border.all(color: Theme
          .of(context)
          .primaryColor),
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      middle: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Flex(
          direction: Axis.horizontal,
          children: _titleList
              .map((title) =>
              Expanded(
                flex: 1,
                child: _buildNavigationTitle(title),
              ))
              .toList(),
        ),
      ),
      leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 20.0,
          ),
          onPressed: () {
            KuGouScaffoldState.of(context).openDrawer();
          }),
      trailing: PopupMenuButton<String>(
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
                child: _buildMenuItem(Icons.music_note, "听歌识曲")),
            PopupMenuDivider(height: 1.0,),
            PopupMenuItem<String>(child: _buildMenuItem(Icons.scanner, "扫一扫")),
            PopupMenuDivider(height: 1.0,),
            PopupMenuItem<String>(child: _buildMenuItem(Icons.code, "我的二维码")),
          ];
        },
        icon: Icon(Icons.add, color: Colors.white,),
        offset: Offset(0.0, 50.0),
      ),
    );
  }

  GestureDetector _buildNavigationTitle(String title) {
    return GestureDetector(
      onTap: () {
        _changeNavigationTitle(_titleList.indexOf(title));
      },
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: _titleList.indexOf(title) == _currentIndex
            ? TextStyle(color: Colors.white, fontSize: 20)
            : TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.grey, size: 20,),
          SizedBox(width: 10.0,),
          Text(title, style: TextStyle(fontSize: 14.0),)
        ],
      ),
    );
  }
}
