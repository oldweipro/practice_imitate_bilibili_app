import 'package:bilibili/db/hi_cache.dart';
import 'package:bilibili/http/dao/login_dao.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/page/home_page.dart';
import 'package:bilibili/page/login_page.dart';
import 'package:bilibili/page/registration_page.dart';
import 'package:bilibili/page/video_detail_page.dart';
import 'package:bilibili/util/color.dart';
import 'package:flutter/material.dart';

import 'model/video_model.dart';

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key key}) : super(key: key);

  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouterDelegate routerDelegate = BiliRouterDelegate();
  BiliRouteInformationParser biliRouteInformationParser =
      BiliRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
      builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(
                routeInformationParser: biliRouteInformationParser,
                routerDelegate: routerDelegate,
                routeInformationProvider: PlatformRouteInformationProvider(
                    initialRouteInformation: RouteInformation(location: '/')),
              )
            : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        return MaterialApp(
          home: widget,
          theme: ThemeData(primarySwatch: white),
        );
      },
      //初始化
      future: HiCache.preInit(),
    );
  }
}

class BiliRouterDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;
  RouteStatus _routeStatus = RouteStatus.home;

  BiliRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  List<MaterialPage> pages = [];

  VideoModel videoModel;
  BiliRoutePath path;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      pages.clear();
      page = pageWrapper(HomePage(
        onJumpToDetail: (videoModel) {
          this.videoModel = videoModel;
          notifyListeners();
        },
      ));
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrapper(VideoDetailPage(
        videoModel: videoModel,
      ));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrapper(RegistrationPage(
        onJumpToLogin: () {
          _routeStatus = RouteStatus.login;
          notifyListeners();
        },
      ));
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrapper(LoginPage());
    }
    tempPages = [...tempPages, page];
    pages = tempPages;

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        } else {
          return true;
        }
      },
    );
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) {
    this.path = path;
  }
}

class BiliRouteInformationParser extends RouteInformationParser<BiliRoutePath> {
  @override
  Future<BiliRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    if (uri.pathSegments.length == 0) {
      return BiliRoutePath.home();
    } else {
      return BiliRoutePath.detail();
    }
  }
}

class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = '/';

  BiliRoutePath.detail() : location = '/detail';
}
