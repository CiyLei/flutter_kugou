import 'dart:convert' show json;

class SearchSongsBean {

  int errcode;
  int status;
  String error;
  SearchSongsData data;

  SearchSongsBean.fromParams({this.errcode, this.status, this.error, this.data});

  factory SearchSongsBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SearchSongsBean.fromJson(json.decode(jsonStr)) : new SearchSongsBean.fromJson(jsonStr);

  SearchSongsBean.fromJson(jsonRes) {
    errcode = jsonRes['errcode'];
    status = jsonRes['status'];
    error = jsonRes['error'];
    data = jsonRes['data'] == null ? null : new SearchSongsData.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"errcode": $errcode,"status": $status,"error": ${error != null?'${json.encode(error)}':'null'},"data": $data}';
  }
}

class SearchSongsData {

  int allowerr;
  int correctiontype;
  int forcecorrection;
  int istag;
  int istagresult;
  int timestamp;
  int total;
  String correctiontip;
  String tab;
  List<SearchSongsAggregationData> aggregation;
  List<SearchSongsInfoData> info;

  SearchSongsData.fromParams({this.allowerr, this.correctiontype, this.forcecorrection, this.istag, this.istagresult, this.timestamp, this.total, this.correctiontip, this.tab, this.aggregation, this.info});

  SearchSongsData.fromJson(jsonRes) {
    allowerr = jsonRes['allowerr'];
    correctiontype = jsonRes['correctiontype'];
    forcecorrection = jsonRes['forcecorrection'];
    istag = jsonRes['istag'];
    istagresult = jsonRes['istagresult'];
    timestamp = jsonRes['timestamp'];
    total = jsonRes['total'];
    correctiontip = jsonRes['correctiontip'];
    tab = jsonRes['tab'];
    aggregation = jsonRes['aggregation'] == null ? null : [];

    for (var aggregationItem in aggregation == null ? [] : jsonRes['aggregation']){
      aggregation.add(aggregationItem == null ? null : new SearchSongsAggregationData.fromJson(aggregationItem));
    }

    info = jsonRes['info'] == null ? null : [];

    for (var infoItem in info == null ? [] : jsonRes['info']){
      info.add(infoItem == null ? null : new SearchSongsInfoData.fromJson(infoItem));
    }
  }

  @override
  String toString() {
    return '{"allowerr": $allowerr,"correctiontype": $correctiontype,"forcecorrection": $forcecorrection,"istag": $istag,"istagresult": $istagresult,"timestamp": $timestamp,"total": $total,"correctiontip": ${correctiontip != null?'${json.encode(correctiontip)}':'null'},"tab": ${tab != null?'${json.encode(tab)}':'null'},"aggregation": $aggregation,"info": $info}';
  }
}

class SearchSongsInfoData {

  int filesize320;
  int privilege320;
  int Accompany;
  int album_audio_id;
  int audio_id;
  int bitrate;
  int duration;
  int fail_process;
  int fail_process_320;
  int fail_process_sq;
  int feetype;
  int filesize;
  int fold_type;
  int isnew;
  int isoriginal;
  int m4afilesize;
  int old_cpy;
  int ownercount;
  int pay_type;
  int pay_type_320;
  int pay_type_sq;
  int pkg_price;
  int pkg_price_320;
  int pkg_price_sq;
  int price;
  int price_320;
  int price_sq;
  int privilege;
  int rp_publish;
  int sourceid;
  int sqfilesize;
  int sqprivilege;
  int srctype;
  String hash320;
  String album_id;
  String album_name;
  String extname;
  String filename;
  String hash;
  String mvhash;
  String othername;
  String othername_original;
  String rp_type;
  String singername;
  String songname;
  String songname_original;
  String source;
  String sqhash;
  String topic;
  String topic_url;
  List<dynamic> group;
  SearchSongsTransParamData trans_param;

  SearchSongsInfoData.fromParams({this.filesize320, this.privilege320, this.Accompany, this.album_audio_id, this.audio_id, this.bitrate, this.duration, this.fail_process, this.fail_process_320, this.fail_process_sq, this.feetype, this.filesize, this.fold_type, this.isnew, this.isoriginal, this.m4afilesize, this.old_cpy, this.ownercount, this.pay_type, this.pay_type_320, this.pay_type_sq, this.pkg_price, this.pkg_price_320, this.pkg_price_sq, this.price, this.price_320, this.price_sq, this.privilege, this.rp_publish, this.sourceid, this.sqfilesize, this.sqprivilege, this.srctype, this.hash320, this.album_id, this.album_name, this.extname, this.filename, this.hash, this.mvhash, this.othername, this.othername_original, this.rp_type, this.singername, this.songname, this.songname_original, this.source, this.sqhash, this.topic, this.topic_url, this.group, this.trans_param});

  SearchSongsInfoData.fromJson(jsonRes) {
    filesize320 = jsonRes['320filesize'];
    privilege320 = jsonRes['320privilege'];
    Accompany = jsonRes['Accompany'];
    album_audio_id = jsonRes['album_audio_id'];
    audio_id = jsonRes['audio_id'];
    bitrate = jsonRes['bitrate'];
    duration = jsonRes['duration'];
    fail_process = jsonRes['fail_process'];
    fail_process_320 = jsonRes['fail_process_320'];
    fail_process_sq = jsonRes['fail_process_sq'];
    feetype = jsonRes['feetype'];
    filesize = jsonRes['filesize'];
    fold_type = jsonRes['fold_type'];
    isnew = jsonRes['isnew'];
    isoriginal = jsonRes['isoriginal'];
    m4afilesize = jsonRes['m4afilesize'];
    old_cpy = jsonRes['old_cpy'];
    ownercount = jsonRes['ownercount'];
    pay_type = jsonRes['pay_type'];
    pay_type_320 = jsonRes['pay_type_320'];
    pay_type_sq = jsonRes['pay_type_sq'];
    pkg_price = jsonRes['pkg_price'];
    pkg_price_320 = jsonRes['pkg_price_320'];
    pkg_price_sq = jsonRes['pkg_price_sq'];
    price = jsonRes['price'];
    price_320 = jsonRes['price_320'];
    price_sq = jsonRes['price_sq'];
    privilege = jsonRes['privilege'];
    rp_publish = jsonRes['rp_publish'];
    sourceid = jsonRes['sourceid'];
    sqfilesize = jsonRes['sqfilesize'];
    sqprivilege = jsonRes['sqprivilege'];
    srctype = jsonRes['srctype'];
    hash320 = jsonRes['320hash'];
    album_id = jsonRes['album_id'];
    album_name = jsonRes['album_name'];
    extname = jsonRes['extname'];
    filename = jsonRes['filename'];
    hash = jsonRes['hash'];
    mvhash = jsonRes['mvhash'];
    othername = jsonRes['othername'];
    othername_original = jsonRes['othername_original'];
    rp_type = jsonRes['rp_type'];
    singername = jsonRes['singername'];
    songname = jsonRes['songname'];
    songname_original = jsonRes['songname_original'];
    source = jsonRes['source'];
    sqhash = jsonRes['sqhash'];
    topic = jsonRes['topic'];
    topic_url = jsonRes['topic_url'];
    group = jsonRes['group'] == null ? null : [];

    for (var groupItem in group == null ? [] : jsonRes['group']){
      group.add(groupItem);
    }

    trans_param = jsonRes['trans_param'] == null ? null : new SearchSongsTransParamData.fromJson(jsonRes['trans_param']);
  }

  @override
  String toString() {
    return '{"filesize320": $filesize320,"privilege320": $privilege320,"Accompany": $Accompany,"album_audio_id": $album_audio_id,"audio_id": $audio_id,"bitrate": $bitrate,"duration": $duration,"fail_process": $fail_process,"fail_process_320": $fail_process_320,"fail_process_sq": $fail_process_sq,"feetype": $feetype,"filesize": $filesize,"fold_type": $fold_type,"isnew": $isnew,"isoriginal": $isoriginal,"m4afilesize": $m4afilesize,"old_cpy": $old_cpy,"ownercount": $ownercount,"pay_type": $pay_type,"pay_type_320": $pay_type_320,"pay_type_sq": $pay_type_sq,"pkg_price": $pkg_price,"pkg_price_320": $pkg_price_320,"pkg_price_sq": $pkg_price_sq,"price": $price,"price_320": $price_320,"price_sq": $price_sq,"privilege": $privilege,"rp_publish": $rp_publish,"sourceid": ${source != null?'${json.encode(source)}':'null'}id,"sqfilesize": $sqfilesize,"sqprivilege": $sqprivilege,"srctype": $srctype,"hash320": ${hash320 != null?'${json.encode(hash320)}':'null'},"album_id": ${album_id != null?'${json.encode(album_id)}':'null'},"album_name": ${album_name != null?'${json.encode(album_name)}':'null'},"extname": ${extname != null?'${json.encode(extname)}':'null'},"filename": ${filename != null?'${json.encode(filename)}':'null'},"hash": ${hash != null?'${json.encode(hash)}':'null'},"mvhash": ${mvhash != null?'${json.encode(mvhash)}':'null'},"othername": ${othername != null?'${json.encode(othername)}':'null'},"othername_original": ${othername_original != null?'${json.encode(othername_original)}':'null'},"rp_type": ${rp_type != null?'${json.encode(rp_type)}':'null'},"singername": ${singername != null?'${json.encode(singername)}':'null'},"songname": ${songname != null?'${json.encode(songname)}':'null'},"songname_original": ${songname_original != null?'${json.encode(songname_original)}':'null'},"source": ${source != null?'${json.encode(source)}':'null'},"sqhash": ${sqhash != null?'${json.encode(sqhash)}':'null'},"topic": ${topic != null?'${json.encode(topic)}':'null'},"topic_url": ${topic_url != null?'${json.encode(topic_url)}':'null'},"group": $group,"trans_param": $trans_param}';
  }
}

class SearchSongsTransParamData {

  int cid;
  int display;
  int display_rate;
  int musicpack_advance;
  int pay_block_tpl;
  int roaming_astrict;

  SearchSongsTransParamData.fromParams({this.cid, this.display, this.display_rate, this.musicpack_advance, this.pay_block_tpl, this.roaming_astrict});

  SearchSongsTransParamData.fromJson(jsonRes) {
    cid = jsonRes['cid'];
    display = jsonRes['display'];
    display_rate = jsonRes['display_rate'];
    musicpack_advance = jsonRes['musicpack_advance'];
    pay_block_tpl = jsonRes['pay_block_tpl'];
    roaming_astrict = jsonRes['roaming_astrict'];
  }

  @override
  String toString() {
    return '{"cid": $cid,"display": $display,"display_rate": $display_rate,"musicpack_advance": $musicpack_advance,"pay_block_tpl": $pay_block_tpl,"roaming_astrict": $roaming_astrict}';
  }
}

class SearchSongsAggregationData {

  int count;
  String key;

  SearchSongsAggregationData.fromParams({this.count, this.key});

  SearchSongsAggregationData.fromJson(jsonRes) {
    count = jsonRes['count'];
    key = jsonRes['key'];
  }

  @override
  String toString() {
    return '{"count": $count,"key": ${key != null?'${json.encode(key)}':'null'}}';
  }
}

