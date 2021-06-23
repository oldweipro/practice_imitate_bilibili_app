import 'package:bilibili/http/dao/login_dao.dart';

enum HttpMethod { GET, POST, PUT, DELETE }
//基础请求

abstract class BaseRequest {
  //请求路由参数/{param}
  var pathParams;

  //是否启用https，默认启用https
  var useHttps = true;

  //设置请求域名
  String authority() {
    return "api.devio.org";
  }

  //请求方法
  HttpMethod httpMethod();

  //请求路由
  String path();

  //生成具体的URL
  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    //http和https切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    if (needLogin()) {
      //给需要登录的接口设置登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    print('url:${uri.toString()}');
    return uri.toString();
  }

  //设置接口是否需要登录
  bool needLogin();

  //请求参数封装
  Map<String, String> params = Map();

  //添加请求参数方法
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  //添加headers参数
  Map<String, dynamic> header = {
    'course-flag': 'fa',
    'auth-token': 'ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa',
  };

  //添加参数方法
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
