import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/core/hi_net_adapter.dart';
import 'package:bilibili/http/core/mock_adapter.dart';
import 'package:bilibili/http/request/base_request.dart';

class HiNet {
  HiNet._();
  static HiNet _instance;
  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse hiNetResponse;
    var error;
    try {
      hiNetResponse = await send(request);
    } on HiNetError catch (e) {
      error = e;
      hiNetResponse = e.data;
      printLog(e.message);
    } catch (e) {
      // 其他异常
      error = e;
      printLog(e);
    }
    if (hiNetResponse == null) {
      printLog(error);
    }
    var result = hiNetResponse.data;
    printLog(result);
    var status = hiNetResponse.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status, result.toString(), data: result);
    }
    return result;
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    printLog('url:${request.url()}');

    /// 使用Mock发送请求
    HiNetAdapter adapter = MockAdapter();
    return adapter.send(request);
    // printLog('method:${request.httpMethod()}');
    // request.addHeader("token", "123");
    // printLog('header:${request.header}');
    // return Future.value({
    //   "statusCode": 200,
    //   "data": {"code": 0, "message": "success"}
    // });
  }

  void printLog(log) {
    print('hi_net:${log.toString()}');
  }
}
