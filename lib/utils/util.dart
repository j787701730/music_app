import 'package:dio/dio.dart';

ajax(String url, sucFun) async {
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
