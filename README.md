# flutter_kugou

学习Flutter，模仿做个酷狗

在 [lib/component/net/net_util.dart](https://github.com/CiyLei/flutter_kugou/blob/master/lib/component/net/net_util.dart) 中添加你的酷狗登录的 cookie
```Dart
Response response = await Dio().get(url, queryParameters: params, options: Options(headers: {
      "Cookie" : "你的登录cookie"
    }));
```

![Image text](https://raw.githubusercontent.com/CiyLei/flutter_kugou/master/screen_img/1.png)
![Image text](https://raw.githubusercontent.com/CiyLei/flutter_kugou/master/screen_img/2.png)
![Image text](https://raw.githubusercontent.com/CiyLei/flutter_kugou/master/screen_img/3.png)
![Image text](https://raw.githubusercontent.com/CiyLei/flutter_kugou/master/screen_img/4.png)
![Image text](https://raw.githubusercontent.com/CiyLei/flutter_kugou/master/screen_img/5.png)
![Image text](https://raw.githubusercontent.com/CiyLei/flutter_kugou/master/screen_img/6.png)