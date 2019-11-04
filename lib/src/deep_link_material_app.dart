import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:deep_link_navigation/src/default_page_loader.dart';
import 'package:deep_link_navigation/src/pop_observer.dart';

// TODO: create versions for material, ios, etc

/// Extension of [MaterialApp] adds deep-linking functionality by orchestrating a native flutter navigator.
class DeepLinkMaterialApp extends MaterialApp {
  /// Internal instance of a native flutter Navigator.
  static final _navigatorKey = GlobalKey<NavigatorState>();

  /// Representation of deep link navigation hierarchy.
  final Map<Type, DeepLinkDispatcher> linkDispatchers;

  /// Route mapping for route not found exception.
  final ErrorMapping<RouteNotFound> routeNotFoundErrorMapping;

  /// Route mappings for custom exception handling.
  final Map<Type, ErrorMapping> customErrorRouteMappings;

  /// {@macro flutter.widgets.widgetsApp.builder}
  ///
  /// Material specific features such as [showDialog] and [showMenu], and widgets
  /// such as [Tooltip], [PopupMenuButton], also require a [Navigator] to properly
  /// function.
  ///
  /// Efficiently rebuilds sandwiched widgets on every meaningful change to [DeepLinkNavigator].
  final Widget Function(BuildContext context, DeepLinkNavigator deepLinkNavigator, Widget child) childBuilder;

  /// Widget to display while waiting for first build to complete.
  /// Defaults to empty container.
  final Widget splashScreen;

  /// Initial route of application.
  /// [RouteNotFound] exception defaults back to this route.
  /// Must contain at least one deep link.
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
    List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
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
    // Custom fields
    @required this.linkDispatchers,
    @required this.routeNotFoundErrorMapping,
    this.customErrorRouteMappings,
    this.childBuilder,
    this.splashScreen,
    @required this.defaultRoute,
  }) :
  assert(defaultRoute.isNotEmpty),
  super(
    key: key,
    navigatorKey: _navigatorKey,
    home: splashScreen ?? Container(),
    navigatorObservers: [
      PopObserver(),
      ...navigatorObservers
    ],
    // Provider for easy access through ListenableProvider.of(context) and rebuild capabilities
    builder: (BuildContext context, Widget child) => ListenableProvider<DeepLinkNavigator>(
      builder: (BuildContext context) => DeepLinkNavigator(
        navigatorKey: _navigatorKey,
        linkDispatchers: linkDispatchers,
        routeNotFoundErrorMapping: routeNotFoundErrorMapping,
        customErrorRouteMappings: customErrorRouteMappings,
        defaultRoute: defaultRoute,
      ),
      dispose: (BuildContext context, DeepLinkNavigator value) => null,
      // Inline extraction of [DeepLinkNavigator] instance
      child: Consumer<DeepLinkNavigator>(
        builder: (BuildContext context, DeepLinkNavigator value, Widget child) => childBuilder != null
          ? childBuilder(context, value, DefaultRouteLoader(child: child))
          : DefaultRouteLoader(child: child),
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