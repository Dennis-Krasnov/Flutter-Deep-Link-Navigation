import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:deep_link_navigation/src/default_page_loader.dart';
import 'package:deep_link_navigation/src/pop_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: extend MaterialApp (TOOD: create versions for material, ios, etc)

/// ...
class DeepLinkMaterialApp extends MaterialApp {
  /// ...
  static final _navigatorKey = GlobalKey<NavigatorState>();

  /// ...
  final Map<Type, DeepLinkDispatcher> linkDispatchers;

  /// ...
  final Map<Type, ErrorDispatcher> errorDispatchers;

  /// ...
  final Widget Function(BuildContext context, DeepLinkNavigator deepLinkNavigator, Widget child) builder2; // TODO: rename

  /// ...
  final Widget splashScreen;

  /// ...
  final List<DeepLink> defaultRoute;

  /// Creates a MaterialApp.
  ///
  /// At least one of [home], [routes], [onGenerateRoute], or [builder] must be
  /// non-null. If only [routes] is given, it must include an entry for the
  /// [Navigator.defaultRouteName] (`/`), since that is the route used when the
  /// application is launched with an intent that specifies an otherwise
  /// unsupported route.
  ///
  /// This class creates an instance of [WidgetsApp].
  ///
  /// The boolean arguments, [routes], and [navigatorObservers], must not be null.
  DeepLinkMaterialApp({
    Key key,
//    GlobalKey<NavigatorState> navigatorKey,
//    Widget home,
//    this.routes = const <String, WidgetBuilder>{},
//    this.initialRoute,
//    this.onGenerateRoute,
//    this.onUnknownRoute,
    List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
//    Widget Function(BuildContext context, DeepLinkNavigator deepLinkNavigator, Widget child) builder,
    String title = '',
    GenerateAppTitle onGenerateTitle,
    Color color,
    ThemeData theme,
    ThemeData darkTheme,
    ThemeMode themeMode = ThemeMode.system,
    Locale locale,
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    LocaleListResolutionCallback localeListResolutionCallback,
    LocaleResolutionCallback localeResolutionCallback,
    Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
    bool debugShowMaterialGrid = false,
    bool showPerformanceOverlay = false,
    bool checkerboardRasterCacheImages = false,
    bool checkerboardOffscreenLayers = false,
    bool showSemanticsDebugger = false,
    bool debugShowCheckedModeBanner = true,
    // ...
    @required this.linkDispatchers,
    @required this.errorDispatchers,
    this.builder2,
    @required this.splashScreen,
    @required this.defaultRoute,
  }) : super(
    key: key,
    navigatorKey: _navigatorKey,
    home: splashScreen,
    navigatorObservers: [
      // ...
      PopObserver(),
      ...navigatorObservers
    ],
//    builder: (BuildContext context, Widget child) => builder(context, null, child), // FIXME inline provider and consumer!
    builder: (BuildContext context, Widget child) => ListenableProvider<DeepLinkNavigator>(
      builder: (BuildContext context) => DeepLinkNavigator(
        navigatorKey: _navigatorKey,
        linkDispatchers: linkDispatchers,
        errorDispatchers: errorDispatchers,
        defaultRoute: defaultRoute,
      ),
      dispose: (BuildContext context, DeepLinkNavigator value) => null,
      child: Consumer<DeepLinkNavigator>(
        builder: (BuildContext context, DeepLinkNavigator value, Widget child) => builder2 != null
          ? builder2(context, value, DefaultPageLoader(child: child))
          : DefaultPageLoader(child: child),
        child: child,
      ),
    ),
    title: title,
    onGenerateTitle: onGenerateTitle,
    color: color,
    theme: theme,
    darkTheme: darkTheme,
    themeMode: themeMode,
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    localeListResolutionCallback: localeListResolutionCallback,
    localeResolutionCallback: localeResolutionCallback,
    supportedLocales: supportedLocales,
    debugShowMaterialGrid: debugShowMaterialGrid,
    showPerformanceOverlay: showPerformanceOverlay,
    checkerboardRasterCacheImages: checkerboardRasterCacheImages,
    checkerboardOffscreenLayers: checkerboardOffscreenLayers,
    showSemanticsDebugger: showSemanticsDebugger,
    debugShowCheckedModeBanner: debugShowCheckedModeBanner,
  );
}