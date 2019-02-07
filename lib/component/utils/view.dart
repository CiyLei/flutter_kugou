import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kugou/bean/play_song_info_bean.dart';
import 'package:flutter_kugou/bean/play_song_list_info_bean.dart';
import 'package:flutter_kugou/component/bloc/kugou_bloc.dart';
import 'package:flutter_kugou/component/net/network_image.dart';

class ViewUtils {
  static void showPlayerList(BuildContext context, KuGouBloc kuGouBloc) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return _buildPlayerList(context, kuGouBloc, onOrderTap: () {
            print("切换顺序");
          }, onItemDeleteTap: (index) {
            kuGouBloc.deletePlayer(index);
          }, onAllDeleteTap: () {
            kuGouBloc.clearPlayerList();
          }, onCancelTap: () {
            Navigator.pop(context);
          }, onItemTap: (index) {
            kuGouBloc.playOfIndex(index);
          });
        });
  }

  static Widget _buildPlayerList(
    BuildContext context,
    KuGouBloc kuGouBloc, {
    VoidCallback onOrderTap,
    ValueChanged onItemTap,
    ValueChanged onItemDeleteTap,
    VoidCallback onAllDeleteTap,
    VoidCallback onCancelTap,
  }) {
    return StreamBuilder(
        initialData: PlaySongInfoBean(),
        stream: kuGouBloc.playStream,
        builder: (_, AsyncSnapshot<PlaySongInfoBean> snapshot) => Container(
              height: MediaQuery.of(context).size.height * 0.7,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      //compare_arrows
                      FlatButton.icon(
                          onPressed: onOrderTap,
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                          label: DefaultTextStyle(
                              style: TextStyle(color: Colors.black),
                              child: Text(
                                  "顺序播放(${kuGouBloc.playListInfo.plays.length})"))),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Material(
                        child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                            onPressed: onAllDeleteTap),
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                  Divider(
                    height: 1.0,
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: kuGouBloc.playListInfo.plays.length,
                      separatorBuilder: (_, _i) => Divider(
                            height: 1.0,
                            indent: 50.0,
                          ),
                      itemBuilder: (_, index) => _buildPlayerListItem(
                          context,
                          index,
                          kuGouBloc.playListInfo,
                          onItemTap,
                          onItemDeleteTap),
                    ),
                  ),
                  Divider(
                    height: 1.0,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onCancelTap,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: DefaultTextStyle(
                          style: TextStyle(color: Colors.black),
                          child: Text(
                            "关闭",
                          )),
                    ),
                  )
                ],
              ),
            ));
  }

  static Widget _buildPlayerListItem(
    BuildContext context,
    int index,
    PlaySongListInfoBean bean,
    ValueChanged onItemTap,
    ValueChanged onItemDeleteTap,
  ) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          onItemTap(index);
        },
        child: Row(
          children: <Widget>[
            Container(
              width: 50.0,
              height: 50.0,
              alignment: Alignment.center,
              child: bean.index == index
                  ? CircleAvatar(
                      radius: 20.0,
                      backgroundImage: MyNetworkImage(bean.plays[index].data.img),
                    )
                  : DefaultTextStyle(
                      style: TextStyle(color: Colors.black, fontSize: 12.0),
                      child: Text("${index < 9 ? "0" : ""}${index + 1}"),
                    ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTextStyle(
                    style: TextStyle(
                        color: index == bean.index
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                        fontSize: 14.0),
                    child: Text(bean.plays[index].data.song_name),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                        color: index == bean.index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        fontSize: 12.0),
                    child: Text(bean.plays[index].data.author_name),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onPressed: () {
                onItemDeleteTap(index);
              },
            )
          ],
        ),
      ),
    );
  }
}
