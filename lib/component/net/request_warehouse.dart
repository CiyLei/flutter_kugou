import 'dart:async';
import 'dart:convert';

import 'package:flutter_kugou/component/net/net_util.dart';
import 'package:flutter_kugou/view/search/song_search_bean.dart';

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
}