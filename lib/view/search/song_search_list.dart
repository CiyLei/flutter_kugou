import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/base_state.dart';
import 'package:flutter_kugou/view/search/bean/search_songs_bean.dart';
import 'package:flutter_kugou/view/search/song_search_list_bloc.dart';
import 'package:flutter/cupertino.dart';

class SongSearchList extends StatefulWidget {
  @override
  _SongSearchListState createState() => _SongSearchListState();
}

class _SongSearchListState
    extends BaseState<SongSearchList, SongSearchListBloc> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder(
            initialData: List<SearchSongsInfoData>(),
            stream: bloc.searchSong,
            builder: (BuildContext context,
                AsyncSnapshot<List<SearchSongsInfoData>> snapshot) {
              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  if (index >= snapshot.data.length) bloc.getNext();
                  return index < snapshot.data.length
                      ? Material(
                          child: InkWell(
                            onTap: () {
                              bloc.playSong(snapshot.data[index].hash, context);
                            },
                            child: _buildItem(index, snapshot.data[index],
                                onAddTap: () {
                              bloc.addSong(snapshot.data[index].hash, context);
                            }, onMoreTap: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (c) {
                                    return Material(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            child: Text("歌曲： ${snapshot.data[index].songname}", style: TextStyle(color: Colors.grey[600]),),
                                          ),
                                          Divider(height: 1,),
                                          _buildSongInfoItem(
                                            context: context,
                                            title: "歌手： ${snapshot.data[index].singername}",
                                            iconData: Icons.person
                                          ),
                                          Divider(height: 1.0, indent: 70,),
                                          _buildSongInfoItem(
                                            context: context,
                                            title: "专辑： ${snapshot.data[index].album_name}",
                                            iconData: Icons.disc_full
                                          ),
                                          Divider(height: 1.0, indent: 70,),
                                          _buildSongInfoItem(
                                            context: context,
                                            title: "比特率： ${snapshot.data[index].bitrate}",
                                            iconData: Icons.ac_unit
                                          ),
                                          Divider(height: 1.0, indent: 70,),
                                          _buildSongInfoItem(
                                            context: context,
                                            title: "文件大小： ${(snapshot.data[index].filesize / 1000.00 / 1000.00).toStringAsFixed(2)} M",
                                            iconData: Icons.format_size
                                          ),
                                          Divider(height: 1.0, indent: 70,),
                                          _buildSongInfoItem(
                                            context: context,
                                            title: "文件Hash值： ${snapshot.data[index].hash}",
                                            iconData: Icons.file_download
                                          ),
                                          Container(
                                            height: 10.0,
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                          ListTile(
                                            title: Text(
                                              "关闭",
                                              textAlign: TextAlign.center,
                                            ),
                                            onTap: () {
                                              Navigator.pop(c);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }),
                          ),
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 70.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "加载中，请稍等",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                      height: 1.0,
                      indent: 65.0,
                    ),
                itemCount: snapshot.data.length + (bloc.isMore ? 1 : 0),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSongInfoItem({BuildContext context, String title, IconData iconData}) {
    assert(title.isNotEmpty);
    return ListTile(
      title: Text(title),
      leading: Icon(
        iconData,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildItem(int index, SearchSongsInfoData data,
      {VoidCallback onAddTap, VoidCallback onMoreTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: Colors.grey,
            onPressed: onAddTap,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: data.songname.startsWith(bloc.song) ? bloc.song : "",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16.0),
                    children: data.songname.split(bloc.song).map((val) {
                      return val.isEmpty
                          ? TextSpan()
                          : TextSpan(
                              text: val,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              children: [
                                  TextSpan(
                                    text: !data.songname.endsWith(val) ||
                                            data.songname.endsWith(bloc.song)
                                        ? bloc.song
                                        : "",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16.0),
                                  )
                                ]);
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${data.singername} ${data.album_name.isNotEmpty ? "- 《${data.album_name}》" : ""}",
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
                SizedBox(
                  height: 3.0,
                ),
                index == 0
                    ? Text(
                        data.songname,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          data.mvhash.isEmpty
              ? SizedBox()
              : Container(
                  padding: const EdgeInsets.only(left: 1.0, top: 1.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      border: Border.all(color: Colors.grey[400])),
                  child: Text(
                    "MV",
                    style: TextStyle(color: Colors.grey, fontSize: 8.0),
                  ),
                ),
//          SizedBox(
//            width: 10.0,
//          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: onMoreTap,
            color: Colors.grey,
          ),
          SizedBox(
            width: 15.0,
          ),
        ],
      ),
    );
  }
}
