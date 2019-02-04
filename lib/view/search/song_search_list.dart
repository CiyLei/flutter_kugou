import 'package:flutter/material.dart';
import 'package:flutter_kugou/component/base_state.dart';
import 'package:flutter_kugou/view/search/search_songs_bean.dart';
import 'package:flutter_kugou/view/search/song_search_list_bloc.dart';

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
                  return Material(
                    child: InkWell(
                      onTap: () {},
                      child: _buildItem(index, snapshot.data[index],
                          onAddTap: () {}, onMoreTap: () {}),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                      height: 1.0,
                      indent: 65.0,
                    ),
                itemCount: snapshot.data.length,
              );
            },
          ),
        ),
        SizedBox(
          height: 60.0,
        )
      ],
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
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.0),
                    children: data.songname.split(bloc.song).map((val) {
                      return val.isEmpty
                          ? TextSpan()
                          : TextSpan(
                          text: val,
                          style: TextStyle(
                              color: Colors.black, fontSize: 14.0),
                          children: [
                            TextSpan(
                              text: !data.songname.endsWith(val) ||
                                  data.songname.endsWith(bloc.song)
                                  ? bloc.song
                                  : "",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14.0),
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
          SizedBox(
            width: 10.0,
          ),
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
