import 'dart:convert';

import 'package:bilibili/http/request/base_request.dart';

abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

class HiNetResponse<T> {
  T data;
  BaseRequest request;
  int statusCode;
  String statusMessage;
  dynamic extra;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }

  HiNetResponse(
      {this.data,
      this.request,
      this.statusCode,
      this.statusMessage,
      this.extra});
}
