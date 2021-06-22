import 'dart:convert';

import 'package:bilibili/http/request/base_request.dart';

abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

class HiNetResponse<T> {
  //返回的数据
  T data;

  //返回请求
  BaseRequest request;

  //返回状态
  int statusCode;

  //返回状态信息
  String statusMessage;

  //额外数据
  dynamic extra;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }

  HiNetResponse(
      //设置为非必填
      {this.data,
      this.request,
      this.statusCode,
      this.statusMessage,
      this.extra});
}
