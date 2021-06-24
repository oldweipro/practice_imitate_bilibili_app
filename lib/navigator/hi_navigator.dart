import 'package:bilibili/page/home_page.dart';
import 'package:bilibili/page/login_page.dart';
import 'package:bilibili/page/registration_page.dart';
import 'package:bilibili/page/video_detail_page.dart';
import 'package:flutter/material.dart';

///创建页面
pageWrapper(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}

int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getRouteStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

enum RouteStatus { login, registration, home, detail, unknown }

RouteStatus getRouteStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget widget;

  RouteStatusInfo(this.routeStatus, this.widget);
}
