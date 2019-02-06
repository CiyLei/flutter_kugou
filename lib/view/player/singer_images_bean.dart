import 'dart:convert' show json;

class SingerImagesBean {

  int error_code;
  int status;
  List<List<SingerImagesData>> data;

  SingerImagesBean.fromParams({this.error_code, this.status, this.data});

  factory SingerImagesBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SingerImagesBean.fromJson(json.decode(jsonStr)) : new SingerImagesBean.fromJson(jsonStr);

  SingerImagesBean.fromJson(jsonRes) {
    error_code = jsonRes['error_code'];
    status = jsonRes['status'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']){
      List<SingerImagesData> dataChild = dataItem == null ? null : [];
      for (var dataItemItem in dataChild == null ? [] : dataItem){
        dataChild.add(dataItemItem == null ? null : new SingerImagesData.fromJson(dataItemItem));
      }
      data.add(dataChild);
    }
  }

  @override
  String toString() {
    return '{"error_code": $error_code,"status": $status,"data": $data}';
  }
}

class SingerImagesData {

  String author_id;
  String author_name;
  String avatar;
  String is_publish;
  String res_hash;
  String sizable_avatar;
  SingerImagesDataImgs imgs;

  SingerImagesData.fromParams({this.author_id, this.author_name, this.avatar, this.is_publish, this.res_hash, this.sizable_avatar, this.imgs});

  SingerImagesData.fromJson(jsonRes) {
    author_id = jsonRes['author_id'];
    author_name = jsonRes['author_name'];
    avatar = jsonRes['avatar'];
    is_publish = jsonRes['is_publish'];
    res_hash = jsonRes['res_hash'];
    sizable_avatar = jsonRes['sizable_avatar'];
    imgs = jsonRes['imgs'] == null ? null : new SingerImagesDataImgs.fromJson(jsonRes['imgs']);
  }

  @override
  String toString() {
    return '{"author_id": ${author_id != null?'${json.encode(author_id)}':'null'},"author_name": ${author_name != null?'${json.encode(author_name)}':'null'},"avatar": ${avatar != null?'${json.encode(avatar)}':'null'},"is_publish": ${is_publish != null?'${json.encode(is_publish)}':'null'},"res_hash": ${res_hash != null?'${json.encode(res_hash)}':'null'},"sizable_avatar": ${sizable_avatar != null?'${json.encode(sizable_avatar)}':'null'},"imgs": $imgs}';
  }
}

class SingerImagesDataImgs {

  List<SingerImagesDataImgs2> imgs2;
  List<SingerImagesDataImgs3> imgs3;
  List<SingerImagesDataImgs4> imgs4;
  List<SingerImagesDataImgs5> imgs5;

  SingerImagesDataImgs.fromParams({this.imgs2, this.imgs3, this.imgs4, this.imgs5});

  SingerImagesDataImgs.fromJson(jsonRes) {
    imgs2 = jsonRes['2'] == null ? null : [];

    for (var imgs2Item in imgs2 == null ? [] : jsonRes['2']){
      imgs2.add(imgs2Item == null ? null : new SingerImagesDataImgs2.fromJson(imgs2Item));
    }

    imgs3 = jsonRes['3'] == null ? null : [];

    for (var imgs3Item in imgs3 == null ? [] : jsonRes['3']){
      imgs3.add(imgs3Item == null ? null : new SingerImagesDataImgs3.fromJson(imgs3Item));
    }

    imgs4 = jsonRes['4'] == null ? null : [];

    for (var imgs4Item in imgs4 == null ? [] : jsonRes['4']){
      imgs4.add(imgs4Item == null ? null : new SingerImagesDataImgs4.fromJson(imgs4Item));
    }

    imgs5 = jsonRes['5'] == null ? null : [];

    for (var imgs5Item in imgs5 == null ? [] : jsonRes['5']){
      imgs5.add(imgs5Item == null ? null : new SingerImagesDataImgs5.fromJson(imgs5Item));
    }
  }

  @override
  String toString() {
    return '{"2": $imgs2,"3": $imgs3,"4": $imgs4,"5": $imgs5}';
  }
}

class SingerImagesDataImgs5 {

  String file_hash;
  String filename;
  String sizable_portrait;

  SingerImagesDataImgs5.fromParams({this.file_hash, this.filename, this.sizable_portrait});

  SingerImagesDataImgs5.fromJson(jsonRes) {
    file_hash = jsonRes['file_hash'];
    filename = jsonRes['filename'];
    sizable_portrait = jsonRes['sizable_portrait'];
  }

  @override
  String toString() {
    return '{"file_hash": ${file_hash != null?'${json.encode(file_hash)}':'null'},"filename": ${filename != null?'${json.encode(filename)}':'null'},"sizable_portrait": ${sizable_portrait != null?'${json.encode(sizable_portrait)}':'null'}}';
  }
}

class SingerImagesDataImgs4 {

  String file_hash;
  String filename;
  String sizable_portrait;

  SingerImagesDataImgs4.fromParams({this.file_hash, this.filename, this.sizable_portrait});

  SingerImagesDataImgs4.fromJson(jsonRes) {
    file_hash = jsonRes['file_hash'];
    filename = jsonRes['filename'];
    sizable_portrait = jsonRes['sizable_portrait'];
  }

  @override
  String toString() {
    return '{"file_hash": ${file_hash != null?'${json.encode(file_hash)}':'null'},"filename": ${filename != null?'${json.encode(filename)}':'null'},"sizable_portrait": ${sizable_portrait != null?'${json.encode(sizable_portrait)}':'null'}}';
  }
}

class SingerImagesDataImgs3 {

  String file_hash;
  String filename;
  String sizable_portrait;

  SingerImagesDataImgs3.fromParams({this.file_hash, this.filename, this.sizable_portrait});

  SingerImagesDataImgs3.fromJson(jsonRes) {
    file_hash = jsonRes['file_hash'];
    filename = jsonRes['filename'];
    sizable_portrait = jsonRes['sizable_portrait'];
  }

  @override
  String toString() {
    return '{"file_hash": ${file_hash != null?'${json.encode(file_hash)}':'null'},"filename": ${filename != null?'${json.encode(filename)}':'null'},"sizable_portrait": ${sizable_portrait != null?'${json.encode(sizable_portrait)}':'null'}}';
  }
}

class SingerImagesDataImgs2 {

  String file_hash;
  String filename;
  String sizable_portrait;

  SingerImagesDataImgs2.fromParams({this.file_hash, this.filename, this.sizable_portrait});

  SingerImagesDataImgs2.fromJson(jsonRes) {
    file_hash = jsonRes['file_hash'];
    filename = jsonRes['filename'];
    sizable_portrait = jsonRes['sizable_portrait'];
  }

  @override
  String toString() {
    return '{"file_hash": ${file_hash != null?'${json.encode(file_hash)}':'null'},"filename": ${filename != null?'${json.encode(filename)}':'null'},"sizable_portrait": ${sizable_portrait != null?'${json.encode(sizable_portrait)}':'null'}}';
  }
}

