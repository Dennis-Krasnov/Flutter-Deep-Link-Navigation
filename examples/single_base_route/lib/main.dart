import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:single_base_route/deep_links.dart';
import 'package:single_base_route/dispatchers.dart';
import 'package:single_base_route/widgets/splash_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(BankingApp());

class BankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DeepLinkMaterialApp(
    // This is where the magic happens
    linkDispatchers: linkDispatchers,
    errorDispatchers: errorDispatchers,
    defaultRoute: [LibraryDL()],
    splashScreen: SplashPage(),
    // Optionally specify always visible widgets
    builder2: (BuildContext context, DeepLinkNavigator deepLinkNavigator, Widget child) => Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(title: Text("one"), icon: Icon(Icons.receipt)),
          BottomNavigationBarItem(title: Text("two"), icon: Icon(Icons.receipt)),
          BottomNavigationBarItem(title: Text("three"), icon: Icon(Icons.receipt)),
        ],
      ),
    ),
    // Non-navigation related fields are still available
    themeMode: ThemeMode.light,
  );


//    return DeepLinkNavigator(
//      navigatorKey: navigatorKey,

//      splashScreen: MaterialApp(
//        // TODO: always create custom Navigator(), need to specify observers (take in as optional params, ...spread user defined observers!)
//        // TODO: think about how to make bottom navigation easily (extra field won't work, can't wrap material app with scaffold)
//        navigatorKey: navigatorKey,
//        home: SplashPage(),
////        builder: (BuildContext context, Widget widget) => Scaffold(
////          body: widget,
////          bottomNavigationBar: BottomNavigationBar(
////            items: [
////              BottomNavigationBarItem(title: Text("1")),
////              BottomNavigationBarItem(title: Text("2")),
////              BottomNavigationBarItem(title: Text("3")),
////            ],
////          ),
////        ),
//      ),
//      defaultRoute: [LibraryDL()],
//    );
//  }
}