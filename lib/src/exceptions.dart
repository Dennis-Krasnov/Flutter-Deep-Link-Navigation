import 'package:deep_link_navigation/deep_link_navigation.dart';

/// Reserved exception thrown when a route didn't match the given navigation hierarchy.
class RouteNotFound implements Exception {
  List<DeepLink> route;
  RouteNotFound(this.route);

  @override
  String toString() => "Route not found: $route";
}