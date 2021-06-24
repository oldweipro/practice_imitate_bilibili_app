import 'package:bilibili/page/home_page.dart';
import 'package:bilibili/page/video_detail_page.dart';
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
    var widget = Router(
      routeInformationParser: biliRouteInformationParser,
      routerDelegate: routerDelegate,
      routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(location: '/')),
    );
    return MaterialApp(
      home: widget,
    );
  }
}

class BiliRouterDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  BiliRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  List<MaterialPage> pages = [];

  VideoModel videoModel;
  BiliRoutePath path;

  @override
  Widget build(BuildContext context) {
    pages = [
      pageWrapper(HomePage(
        onJumpToDetail: (videoModel) {
          this.videoModel = videoModel;
          notifyListeners();
        },
      )),
      if (videoModel != null)
        pageWrapper(VideoDetailPage(
          videoModel: videoModel,
        ))
    ];
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

pageWrapper(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}
