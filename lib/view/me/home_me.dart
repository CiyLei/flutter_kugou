import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/bloc/bloc_provider.dart';
import 'package:flutter_kugou/model/collection_model.dart';
import 'dart:math';

import 'package:flutter_kugou/view/home_page_bloc.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> with AutomaticKeepAliveClientMixin{
  List<CollectionModel> testCollectionModel;
  ScrollController _scrollController;
  HomePageBloc _homePageBloc;

  @override
  void initState() {
    super.initState();
    _homePageBloc = BlocProvider.of<HomePageBloc>(context);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_homePageBloc.searchIsExpand && _scrollController.offset > 350.0) {
        _homePageBloc.closeSearch();
      } else if (!_homePageBloc.searchIsExpand && _scrollController.offset < 350.0) {
        _homePageBloc.expandSearch();
      }
    });
    testCollectionModel = [
      CollectionModel(
          name: "抖音最火的中文歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228105204294090.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "每周推荐歌曲",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20190202/20190202120819421303.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
      CollectionModel(
          name: "最让人心痛的情歌",
          imageUrl:
              "http://imge.kugou.com/soft/collection/150/20181228/20181228004601158047.jpg",
          songNum: 302,
          downLoadNum: 173),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder(
          stream: _homePageBloc.searchHeightStream,
          initialData: 0.0,
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            return Container(
              height: 60.0 - snapshot.data,
              color: Theme.of(context).primaryColor,
            );
          },
        ),
        StreamBuilder(
          stream: _homePageBloc.searchHeightStream,
          initialData: 0.0,
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            return Padding(
              padding: EdgeInsets.only(top: 50.0 - snapshot.data),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0))),
                constraints: BoxConstraints.tightFor(),
              ),
            );
          },
        ),
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 50.0,),
                _buildUserInfo("Ciy雷", "5", "13583"),
                Container(
                  color: Colors.grey[200],
                  height: 1.0,
                ),
                _buildSongNum(200, 302, 199, 296),
                Container(
                  color: Colors.grey[200],
                  height: 10.0,
                ),
                _buildMainItem("K歌作品", "", () {}),
                _buildMainItem("音乐圈", "", () {}),
                SongList(
                  collections: testCollectionModel,
                ),
                _buildMainItem("推广", "音乐识别神器"),
              ]),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 80.0),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildUserInfo(String userName, String grade, String listenTime) {
    return Container(
      padding: const EdgeInsets.only(
          left: 15.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
                "http://imge.kugou.com/kugouicon/165/20150210/20150210134948327295.jpg"),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userName,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          border: Border.all(color: Colors.orangeAccent)),
                      child: Text(
                        "LV.$grade",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 10.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text("听歌$listenTime分钟",
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        textAlign: TextAlign.center)
                  ],
                )
              ],
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.message,
                color: Colors.grey,
                size: 30.0,
              ),
              onPressed: () {})
        ],
      ),
    );
  }

  Widget _buildSongNum(int local, int collection, int download, int recent) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildSongNumItem("本地音乐", Icons.phone_iphone, local),
          _buildSongNumItem("我的收藏", Icons.color_lens, collection),
          _buildSongNumItem("下载", Icons.cloud_download, download),
          _buildSongNumItem("最近播放", Icons.timelapse, recent),
        ],
      ),
    );
  }

  Widget _buildSongNumItem(String name, IconData icon, int num) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            "$num",
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Widget _buildMainItem(String title, String description,
      [GestureTapCallback onTap]) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14.0),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      description,
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              height: 1.0,
              decoration: BoxDecoration(color: Colors.grey[200]),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SongList extends StatefulWidget {
  SongList({this.collections}) {
    if (this.collections == null) {
      this.collections = [];
    }
  }

  List<CollectionModel> collections;

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList>
    with SingleTickerProviderStateMixin {
  AnimationController _expandController;
  bool isExpand;

  @override
  void initState() {
    super.initState();
    isExpand = false;
    _expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isExpand) {
          _expandController.reverse();
          isExpand = false;
        } else {
          _expandController.forward();
          isExpand = true;
        }
        setState(() {});
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "自建歌单",
                  style: TextStyle(fontSize: 14.0),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: AnimatedBuilder(
                            animation: _expandController,
                            builder: (buildContext, child) {
                              return Transform.rotate(
                                angle: pi * _expandController.value,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                              );
                            }),
                        onPressed: () {}),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
                IconButton(
                  icon: Icon(
                    Icons.format_list_numbered_rtl,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
            _buildList(),
            Container(
              height: 1.0,
              decoration: BoxDecoration(color: Colors.grey[200]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (isExpand) {
      return Column(
        children: widget.collections.map((val) {
          return Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {},
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    child: Row(
                      children: <Widget>[
                        Material(
                          child: Image.network(
                            val.imageUrl,
                            width: 50.0,
                            height: 50.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          clipBehavior: Clip.antiAlias,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                val.name,
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "${val.songNum}首, ${val.downLoadNum}首已下载",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.grey[300],
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 70.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey[200])),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      );
    }
    return SizedBox();
  }
}
