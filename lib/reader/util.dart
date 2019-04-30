import 'package:dio/dio.dart';

const key = '&appkey=cf914ae46ccab40d7f1ad39e93cd79ce';

ajax(String url, sucFun) async {
  print(url);
  try {
    Response response;
    response = await Dio().get(
      "$url",
    );
    sucFun(response.data);
  } catch (e) {
    return print(e);
  }
}
