import 'package:dio/dio.dart';

const baseUrl = 'https://api.itooi.cn/music/netease';

ajax(String url, sucFun) async {
//  print("$baseUrl$url");
  try {
    Response response;
    response = await Dio().get(
      "$baseUrl$url",
    );
    sucFun(response.data);
  } catch (e) {
    return print(e);
  }
}
