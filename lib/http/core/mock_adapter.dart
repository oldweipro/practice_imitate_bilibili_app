import 'package:bilibili/http/core/hi_net_adapter.dart';
import 'package:bilibili/http/request/base_request.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    //delayed演示1000毫秒
    return Future<HiNetResponse>.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse(
          data: {"code": 0, "message": 'success'}, statusCode: 200);
    });
  }
}
