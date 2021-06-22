import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/core/hi_net_adapter.dart';
import 'package:bilibili/http/request/base_request.dart';
import 'package:dio/dio.dart';

/// DIO适配器 通过dio发送网络请求
class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    //参数设置
    var response, options = Options(headers: request.header);
    var error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.PUT) {
        response = await Dio()
            .put(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      /// 跑出HiNet异常
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: buildResult(response, request));
    }
    return buildResult(response, request);
  }

  /// 构建HiNetResponse
  HiNetResponse buildResult(Response response, BaseRequest request) {
    return HiNetResponse(
        data: response.data,
        request: request,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        extra: response);
  }
}
