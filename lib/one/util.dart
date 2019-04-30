import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const key = '?channel=wdj&version=4.5.0&uuid=ffffffff-a90e-706a-63f7-ccf973aae5e1&platform=android';

const category = {'1': 'ONE STORY', '2': '连载', '3': '问答', '4': '音乐', '5': '影视'};

ajax(String url, sucFun) async {
  print("$url$key");
  try {
    Response response;
    response = await Dio().get(
      "$url$key",
//      data: data,
//      options: new Options(
////            contentType: ContentType.parse("application/x-www-form-urlencoded"),
////            contentType: ContentType.json,
//          headers: {
//            'X-Channel-Code': 'official',
//            'X-Client-Agent': 'Xiaomi',
//            'X-Client-Hash': '2f3d6ffkda95dlz2fhju8d3s6dfges3t',
//            'X-Client-ID': '123456789123456',
//            'X-Client-Version': '2.3.2',
//            'X-Long-Token': '',
//            'X-Platform-Type': '0',
//            'X-Platform-Version': '5.0',
//            'X-Serial-Num': DateTime.now().millisecondsSinceEpoch,
//            'X-User-ID': '',
//            // 'Content-Type': 'application/x-www-form-urlencoded',
//          }),
    );

//    if (response.data['err_code'] == 0) {
//      if (toast == true) {
//        showADialog(context, response.data['err_msg']);
//      }
//      if (sucFun != null) {
//        sucFun(response.data);
//      }
//    } else if (response.data['err_code'] == 88888) {
//      // 登录处理
//      showADialog(context, response.data['err_msg']);
//    } else {
//      showADialog(context, response.data['err_code']);
//      if (failFun != null) {
//        failFun(response.data);
//      }
//    }
    sucFun(response.data);
  } catch (e) {
    return print(e);
  }
}
