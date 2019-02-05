import 'dart:convert' show json;

class SearchBean {

  int errcode;
  int recordcount;
  int status;
  String error;
  List<SearchInfoBean> data;

  SearchBean.fromParams({this.errcode, this.recordcount, this.status, this.error, this.data});

  factory SearchBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SearchBean.fromJson(json.decode(jsonStr)) : new SearchBean.fromJson(jsonStr);

  SearchBean.fromJson(jsonRes) {
    errcode = jsonRes['errcode'];
    recordcount = jsonRes['recordcount'];
    status = jsonRes['status'];
    error = jsonRes['error'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']){
      data.add(dataItem == null ? null : new SearchInfoBean.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"errcode": $errcode,"recordcount": $recordcount,"status": $status,"error": ${error != null?'${json.encode(error)}':'null'},"data": $data}';
  }
}

class SearchInfoBean {

  int searchcount;
  int songcount;
  String keyword;

  SearchInfoBean.fromParams({this.searchcount, this.songcount, this.keyword});

  SearchInfoBean.fromJson(jsonRes) {
    searchcount = jsonRes['searchcount'];
    songcount = jsonRes['songcount'];
    keyword = jsonRes['keyword'];
  }

  @override
  String toString() {
    return '{"searchcount": $searchcount,"songcount": $songcount,"keyword": ${keyword != null?'${json.encode(keyword)}':'null'}}';
  }
}

