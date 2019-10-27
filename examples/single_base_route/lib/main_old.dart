//import 'package:deep_link_navigation/deep_link_navigation.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//
//import 'package:single_base_route/deep_link_router.dart';
//import 'package:single_base_route/deep_links.dart';
//
//void main() => runApp(BankingApp());
//
//class BankingApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      // TODO: generics is for DeepLinkNavigatorType!!! (not to do BlocProvider<T>.of(context)...)
////      home: Provider<DeepLinkNavigator>( // TODO: custom provider
//      home: ListenableProvider<DeepLinkNavigator>( // TODO: custom provider
//          builder: (BuildContext context) => DeepLinkNavigator( // TODO: creates automatically
//          navigator: Navigator.of(context), // TODO: create new, wrap with willPopScope... (allow to specify key)
//          defaultRoute: [BankAccountsDL()],
//        ),
//        dispose: (BuildContext context, DeepLinkNavigator value) => null, //value?.dispose(), // TODO: unsubscribe from pop listener automatically
//        child: DeepLinkRouter(),
//      ),
//      // TODO: optionally don't create navigator instantly (create on will poop anyway)
//      // create it further down widget tree (to insert scaffold with bottom nav in middle for example)
//      //
//    );
//  }
//}