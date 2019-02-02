import 'package:flutter/material.dart';

class KuGouDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KuGouDrawerState();
  }
}

class _KuGouDrawerState extends State<KuGouDrawer> {
  bool _notificationBarLyrics = false;

  final List<ItemModel> items = [
    ItemModel(icon: Icons.message, title: "消息中心", onTap: (){}),
    ItemModel(icon: Icons.print, title: "皮肤中心", description: "全村的希望", onTap: (){}),
    ItemModel(icon: Icons.verified_user, title: "会员中心", onTap: (){}),
    ItemModel(icon: Icons.card_giftcard, title: "流量包月", description: "听歌免流量", onTap: (){}),
    ItemModel(icon: Icons.cloud, title: "私人云盘", onTap: (){}),
    ItemModel(icon: Icons.timer, title: "定时关闭", onTap: (){}),
    ItemModel(icon: Icons.av_timer, title: "音乐闹钟", onTap: (){}),
    ItemModel(icon: Icons.line_style, title: "蝰蛇音效", onTap: (){}),
    ItemModel(icon: Icons.sort_by_alpha, title: "听歌识曲", onTap: (){}),
    ItemModel(icon: Icons.content_cut, title: "音乐工具", description: "听觉保护等", onTap: (){}),
    ItemModel(icon: Icons.directions_car, title: "驾驶模式", onTap: (){}),
    ItemModel(icon: Icons.ring_volume, title: "铃声彩铃", onTap: (){}),
    ItemModel(icon: Icons.wb_sunny, title: "儿童专区", description: "快乐成长 有我陪伴", onTap: (){}),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
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
                                _notificationBarLyrics =
                                    !_notificationBarLyrics;
                              });
                            })));
                  }
                  return _buildItem(items[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index == 4 || index == 12 || index == 13)
                    return Divider(
                      height: 20.0,
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
                  title: "说明",
                  onTap: (){},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ItemModel model) {
    return Material(
      child: InkWell(
        onTap: model.onTap,
        child: Container(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0),
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
                style: TextStyle(color: Colors.black),
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
                              style: TextStyle(color: Colors.grey),
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
