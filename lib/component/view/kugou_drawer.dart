import 'package:flutter/material.dart';

class KuGouScaffold extends StatefulWidget {
  KuGouScaffold({this.drawer, this.child});

  Widget drawer;
  Widget child;

  @override
  KuGouScaffoldState createState() => KuGouScaffoldState();
}

class KuGouScaffoldState extends State<KuGouScaffold> {
  ScrollController _controller;
  double _scrollOffset;
  bool _isDrawer;
  double _progress;
  bool drawerEnable;

  bool get isDrawer => _isDrawer;

  @override
  void initState() {
    super.initState();
    drawerEnable = true;
    _isDrawer = false;
    _progress = 0.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollOffset = MediaQuery.of(context).size.width * 0.8;
    _controller = ScrollController(initialScrollOffset: _scrollOffset);
    _controller.addListener(() {
      setState(() {
        _progress = (_scrollOffset - _controller.offset) / _scrollOffset;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  static KuGouScaffoldState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<KuGouScaffoldState>())
        as KuGouScaffoldState;
  }

  void openDrawer() {
    _controller.animateTo(0.0,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
    setState(() {
      _isDrawer = true;
    });
  }

  void closeDrawer() {
    _controller.animateTo(_scrollOffset,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
    setState(() {
      _isDrawer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
     * 据flutter的issues[13350]所提，release模式下因为构建的太快了
     * 在第一帧产生前就执行到了didChangeDependencies，所以这时候我们获取屏幕大小为0，所以_scrollOffset为0.
     * 如果这时候build的时候设置了这个为0的偏移，那么后面就不会偏移了。
     * 如果flutter构建的太快，在第一帧生成前执行了didChangeDependencies和build，
     * 那么在第一帧生成后会再执行一边，所以我们这里判断_scrollOffset为0就不继续下去了。
     */
    if (_scrollOffset == 0)
      return Text("你太快啦");
    return Material(
      child: Listener(
        onPointerUp: (PointerUpEvent event) {
          if (_controller.offset >= _scrollOffset / 2) {
            closeDrawer();
          } else {
            openDrawer();
          }
        },
        child: NotificationListener<KuGouDrawerNotification>(
          onNotification: (notification) {
            setState(() {
              // 接收到是否禁止侧滑的消息
              this.drawerEnable = notification.drawerEnable;
            });
          },
            child: SingleChildScrollView(
          // 禁止在ios中的弹簧效果
          physics: drawerEnable ? ClampingScrollPhysics() : NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: _controller,
          child: Row(
            children: <Widget>[
              Container(
                width: _scrollOffset,
                child: widget.drawer,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: widget.child,
                    foregroundDecoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, _progress * 0.5)),
                  ),
                  _isDrawer
                      ? GestureDetector(
                          onTap: () {
                            closeDrawer();
                          },
                          child: AbsorbPointer(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}

// 是否禁止侧滑菜单的载体
class KuGouDrawerNotification extends Notification {
  bool drawerEnable;

  KuGouDrawerNotification({this.drawerEnable = true});
}

class KuGouDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KuGouDrawerState();
  }
}

class _KuGouDrawerState extends State<KuGouDrawer> {
  bool _notificationBarLyrics = false;

  final List<ItemModel> items = [
    ItemModel(icon: Icons.message, title: "消息中心", onTap: () {}),
    ItemModel(
        icon: Icons.print, title: "皮肤中心", description: "全村的希望", onTap: () {}),
    ItemModel(icon: Icons.verified_user, title: "会员中心", onTap: () {}),
    ItemModel(
        icon: Icons.card_giftcard,
        title: "流量包月",
        description: "听歌免流量",
        onTap: () {}),
    ItemModel(icon: Icons.cloud, title: "私人云盘", onTap: () {}),
    ItemModel(icon: Icons.timer, title: "定时关闭", onTap: () {}),
    ItemModel(icon: Icons.av_timer, title: "音乐闹钟", onTap: () {}),
    ItemModel(icon: Icons.line_style, title: "蝰蛇音效", onTap: () {}),
    ItemModel(icon: Icons.sort_by_alpha, title: "听歌识曲", onTap: () {}),
    ItemModel(
        icon: Icons.content_cut,
        title: "音乐工具",
        description: "听觉保护等",
        onTap: () {}),
    ItemModel(icon: Icons.directions_car, title: "驾驶模式", onTap: () {}),
    ItemModel(icon: Icons.ring_volume, title: "铃声彩铃", onTap: () {}),
    ItemModel(
        icon: Icons.wb_sunny,
        title: "儿童专区",
        description: "快乐成长 有我陪伴",
        onTap: () {}),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 14,
              itemBuilder: (BuildContext context, int index) {
                if (index == 13) {
                  return _buildItem(ItemModel(
                      icon: Icons.receipt,
                      title: "通知栏歌词",
                      child: Switch.adaptive(
                          value: _notificationBarLyrics,
                          activeColor: Colors.lightBlue,
                          onChanged: (value) {
                            this.setState(() {
                              _notificationBarLyrics = !_notificationBarLyrics;
                            });
                          })));
                }
                return _buildItem(items[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                if (index == 4)
                  return Divider(
                    height: 30.0,
                  );
                else if (index == 12)
                  return Divider(
                    height: 10.0,
                  );
                return SizedBox();
              },
            ),
          ),
          Divider(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: _buildItem(
              ItemModel(
                icon: Icons.settings,
                title: "设置",
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(ItemModel model) {
    return Material(
      child: InkWell(
        onTap: model.onTap,
        child: Container(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0),
          child: Row(
            children: <Widget>[
              Icon(
                model.icon,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                model.title,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      model.description != null
                          ? Text(
                              model.description,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14.0),
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 5.0,
                      ),
                      model.child != null ? model.child : SizedBox()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemModel {
  IconData icon;
  String title;
  String description;
  GestureTapCallback onTap;
  Widget child;

  ItemModel(
      {@required this.icon,
      @required this.title,
      this.onTap,
      this.description,
      this.child});
}
