import 'package:deep_link_navigation/deep_link_navigation.dart';

/// Maps error and failed route to another route.
typedef ErrorMapping<E> = List<DeepLink> Function(E exception, List<DeepLink> failedRoute);

/// Reserved exception thrown when a route didn't match the given configuration.
class RouteNotFound implements Exception {
  List<DeepLink> route;

  RouteNotFound(this.route);

  @override
  String toString() => "Route not found: $route";
}