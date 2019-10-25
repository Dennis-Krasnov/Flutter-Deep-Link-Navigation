//import 'package:deep_link_navigation/src/logic/deep_link_navigator.dart';
//import 'package:flutter/widgets.dart';
//import 'package:provider/provider.dart';
//
///// ...
//class DeepLinkNavigatorProvider<T> extends ValueDelegateWidget<T> implements SingleChildCloneableWidget {
//  /// The [Widget] and its descendants which will have access to the [DeepLinkNavigatorProvider].
//  final Widget child;
//
//  /// ...
//  final List<T> baseRoutes;
//
//  /// Takes a [ValueBuilder] that is responsible for builder the child which will have access to the
//  /// deep link navigator via `DeepLinkNavigatorProvider.of(context)`.
//  /// It is used as a dependency injection (DI) widget so that a single instance of a deep link navigator
//  /// can be provided to multiple widgets within a subtree.
//  ///
//  /// Automatically handles closing the bloc when used with a `builder`. // TODO
//  ///
//  /// ```dart
//  /// BlocProvider(
//  ///   builder: (BuildContext context) => BlocA(), // TODO
//  ///   child: ChildA(),
//  /// );
//  /// ```
//
//  DeepLinkNavigatorProvider.singleBaseRoute({
//    Key key,
//    Widget child,
//  }) : this._(
//    key: key,
//    delegate: SingleValueDelegate<T>(null), // FIXME
//    child: child,
//    baseRoutes: [
//
//    ],
//  );
//
//
//  // TODO: factory DeepLinkNavigatorProvider.singleBaseRoute()
//
////  DeepLinkNavigatorProvider({
////    Key key,
//////    ValueBuilder<T> builder,
////    Widget child,
////  }) : this._(
////    key: key,
////    delegate: BuilderStateDelegate<T>(
////      (BuildContext context) => DeepLinkNaviator<T>(),
////      dispose: (_, bloc) => bloc?.close(),
////    ),
////    child: child,
////  );
//
////  DeepLinkNavigatorProvider({Key key, this.child, @required this.baseRoutes})
////    : assert(baseRoutes.isNotEmpty),
////      super(
////        key: key,
////        delegate: BuilderStateDelegate<T>(
////          builder,
////          dispose: (_, bloc) => bloc?.close(),
////        ),
////      );
////  DeepLinkNavigatorProvider({
////    Key key,
////    ValueBuilder<T> builder, // TODO: don't expose!
////    Widget child,
////
////  }) : this._(
////    key: key,
////    delegate: BuilderStateDelegate<T>(
////      builder, // TODO: subscribe to pops
////      dispose: (_, bloc) => null, //bloc?.close(), // TODO: unsubscribe to pops
////    ),
////    child: child,
////  );
//
//  /// Internal constructor responsible for creating the `DeepLinkNavigatorProvider`.
//  /// Used by the `DeepLinkNavigatorProvider` default and `value` constructors.
//  DeepLinkNavigatorProvider._({
//    Key key,
//    ValueStateDelegate<T> delegate,
//    this.child,
//    this.baseRoutes,
//  }) : super(key: key, delegate: delegate ?? SingleValueDelegate<T>(null)); // FIXME
////  DeepLinkNavigatorProvider._({
////    this.key,
////    @required ValueStateDelegate<T> delegate,
////    this.child,
////    this.baseRoutes,
////  }) : super(key: key, delegate: delegate);
//
//  /// Method that allows widgets to access a bloc instance as long as their `BuildContext`
//  /// contains a [DeepLinkNavigatorProvider] instance.
//  ///
//  /// If we want to access the navigator with base routes of `Page`
//  /// which was provided higher up in the widget tree we can do so via:
//  ///
//  /// ```dart
//  /// DeepLinkNavigatorProvider.of<Page>(context)
//  /// ```
//  static DeepLinkNavigator<T> of<T>(BuildContext context) {
//    try {
//      return Provider.of<DeepLinkNavigator<T>>(context, listen: false);
//    } catch (_) {
//      throw FlutterError( // TODO
//        """
//        BlocProvider.of() called with a context that does not contain a Bloc of type $T.
//        No ancestor could be found starting from the context that was passed to BlocProvider.of<$T>().
//        This can happen if:
//        1. The context you used comes from a widget above the BlocProvider.
//        2. You used MultiBlocProvider and didn\'t explicity provide the BlocProvider types.
//        Good: BlocProvider<$T>(builder: (context) => $T())
//        Bad: BlocProvider(builder: (context) => $T()).
//        The context used was: $context
//        """,
//      );
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) =>
//    InheritedProvider<T>(
//      value: delegate.value,
//      child: child,
//    );
//
//  @override
//  DeepLinkNavigatorProvider<T> cloneWithChild(Widget child) =>
//    DeepLinkNavigatorProvider<T>._(
//      key: key,
//      delegate: delegate,
//      child: child,
//    );
//}