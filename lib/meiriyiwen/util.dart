import 'package:dio/dio.dart';

const key = '&key=2a97d3b007e58';

ajax(String url, sucFun) async {
//  print("$url");
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
