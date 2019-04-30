import 'package:dio/dio.dart';

ajax(String url, sucFun) async {
  print("$url");
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
