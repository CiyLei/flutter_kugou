import 'dart:async';
import 'dart:convert';

import 'package:flutter_kugou/view/player/singer_images_bean.dart';
import 'package:flutter_kugou/view/player/song_info_bean.dart';
import 'package:flutter_kugou/component/net/net_util.dart';
import 'package:flutter_kugou/view/search/bean/search_songs_bean.dart';
import 'package:flutter_kugou/view/search/bean/song_search_bean.dart';

class RequestWareHouse {
  // 表示只有内部才可以创建这个类
  RequestWareHouse._();

  static RequestWareHouse _instance;

  factory RequestWareHouse.instance() {
    if (_instance == null) {
      _instance = RequestWareHouse._();
    }
    return _instance;
  }

  Future<SearchBean> getSearchSongName(String songName) async{
    String response = await NetUtil.GET(
      url: "http://mobilecdngz.kugou.com/new/app/i/search.php",
      params: {
        "cmd": "302",
        "keyword": songName
      },
    );
    return SearchBean.fromJson(json.decode(response));
  }

  Future<SearchSongsBean> getSearchSong(String song, {page = 1}) async{
    String response = await NetUtil.GET(
      url: "http://msearchcdn.kugou.com/api/v3/search/song",
      params: {
        "keyword": song,
        "page": "$page",
        "pagesize": "30"
      },
    );
    return SearchSongsBean.fromJson(json.decode(response));
  }

  Future<SongInfoBean> getSongInfo(String hash) async{
    String response = await NetUtil.GET(
      url: "http://www.kugou.com/yy/index.php?r=play/getdata",
      params: {
        "hash": hash,
      },
    );
    return SongInfoBean.fromJson(json.decode(response));
  }

  Future<SingerImagesBean> getSingerImages(String hash, String songName, String singerId) async{
    dynamic data = await NetUtil.POST(
      url: "http://kmr.service.kugou.com/v1/author_image/audio",
      params: {
        "clienttime": "0",
        "mid": "0",
        "clientver": "0",
        "key": "0",
        "appid": "0",
        "data": [{
          "hash": hash,
          "filename": songName,
          "album_audio_id": singerId,
        }],
      },
    );
    return SingerImagesBean.fromJson(data);
  }
}