import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// DeepLinkNavigatorProvider<String>(
//        baseRoutes: [
//          "bank-account"
//        ],

/// ...
//class DeepLinkNavigator extends StatefulWidget {
//  @override
//  _DeepLinkNavigatorState createState() => _DeepLinkNavigatorState();
//}
//
//class _DeepLinkNavigatorState extends State<DeepLinkNavigator> {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}

//class DeepLinkNavigatorProvider<T> extends ValueDelegateWidget<T> implements SingleChildCloneableWidget {
//  /// The [Widget] and its descendants which will have access to the [DeepLinkNavigatorProvider].
//  final Widget child;
//
//  DeepLinkNavigatorProvider({
//    Key key,
//    Widget child,
//  }) : this._(
//    key: key,
//    delegate: BuilderStateDelegate<T>(
//      (BuildContext context) => DeepLinkNavigator<T>(),
//      dispose: (BuildContext context, T value) => null
//    ),
//    child: child,
//  );
//
//  DeepLinkNavigatorProvider._({
//    Key key,
//    @required ValueStateDelegate<T> delegate,
//    this.child,
//  }) : super(key: key, delegate: delegate);
//
//  static T of<T>(BuildContext context) {
//    try {
//      return Provider.of<T>(context, listen: false);
//    } catch (_) {
//      throw FlutterError(
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
//  SingleChildCloneableWidget cloneWithChild(Widget child) =>
//    DeepLinkNavigatorProvider<T>._(
//      key: key,
//      delegate: delegate,
//      child: child,
//    );
//}

//class DeepLinkNavigatorProvider<T> extends ValueDelegateWidget<T> implements SingleChildCloneableWidget{
//  /// The [Widget] and its descendants which will have access to the [DeepLinkNavigatorProvider].
//  final Widget child;
//
//  /// ...
//  final List<T> baseRoutes;
//
//  DeepLinkNavigatorProvider({Key key, this.child, @required this.baseRoutes})
//    : assert(baseRoutes.isNotEmpty), super(key: key, delegate: delegate);
//
//  DeepLinkNavigatorProvider.singleBaseRoute({Key key, this.child})
//    : baseRoutes = [], super(key: key, delegate: delegate);
//
//  static T of<T extends DeepLinkNavigator<T>>(BuildContext context) {
//    try {
//      return Provider.of<T>(context, listen: false);
//    } catch (_) {
//      throw FlutterError(
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
//  SingleChildCloneableWidget cloneWithChild(Widget child) =>
//    DeepLinkNavigatorProvider<T>(
//      key: key,
//      child: child,
//    );
//
//  DeepLinkNavigatorProvider({Key key, this.child, @required this.baseRoutes})
//      : assert(baseRoutes.isNotEmpty), super(key: key, delegate: delegate);
//
////    DeepLinkNavigatorProvider<T>._(
////      key: key,
////      delegate: delegate,
////      child: child,
////    );
//}