import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/core/hi_net_adapter.dart';
import 'package:bilibili/http/request/base_request.dart';

import 'dio_adapter.dart';

class HiNet {
  //单例模式
  HiNet._();

  static HiNet _instance;

  //静态方法获取单例
  static HiNet getInstance() {
    //懒汉式
    if (_instance == null) {
      //用的时候才创建
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
  }

  //发送请求方法
  Future<dynamic> send<T>(BaseRequest request) async {
    printLog('url:${request.url()}');
    printLog('method:${request.httpMethod()}');
    // 底层网络库的切换,当前使用Dio发送请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net:${log.toString()}');
  }
}
