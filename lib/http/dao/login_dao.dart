import 'package:bilibili/db/hi_cache.dart';
import 'package:bilibili/http/core/hi_net.dart';
import 'package:bilibili/http/request/base_request.dart';
import 'package:bilibili/http/request/login_request.dart';
import 'package:bilibili/http/request/registration_request.dart';

class LoginDao {
  static const BOARDING_PASS = 'boarding-pass';
  static login(String username, String password) {
    return _send(username, password);
  }

  static registration(
      String username, String password, String userId, String orderId) {
    return _send(username, password, userId: userId, orderId: orderId);
  }

  static _send(String username, String password, {userId, orderId}) async {
    BaseRequest request;
    if (userId != null && orderId != null) {
      request = RegistrationRequest();
    } else {
      request = LoginRequest();
    }
    request
        .add("userName", username)
        .add("password", password)
        .add("imoocId", userId)
        .add("orderId", orderId);
    var result = await HiNet.getInstance().fire(request);
    print("object:$result");
    if (result['code'] == 0 && result['data'] != null) {
      //登录成功,缓存token（登录令牌）
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }
}
