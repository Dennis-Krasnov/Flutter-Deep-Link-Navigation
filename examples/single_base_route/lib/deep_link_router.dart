import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/material.dart';
import 'package:single_base_route/bank_account_list_screen.dart';
import 'package:single_base_route/deep_links.dart';
import 'package:single_base_route/model.dart';

class DeepLinkRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DeepLinkConsumer({
    BankAccountsDL: DeepLinkDispatcher((path, push) { // TODO: PathDLDispatcher
      push(BankAccountListScreen(path));

      return {
        BankAccountDetailsDL: DeepLinkDispatcher<BankAccount>.value((path, value, push) {
          push(Scaffold(appBar: AppBar(title: Text("value: $value"))));

          return null;
        }),
        SettingsDL: DeepLinkDispatcher((path, push) {
          push(Scaffold(appBar: AppBar(title: Text(path))));

          return {
            AdvancedSettingsDL: DeepLinkDispatcher((path, push) {
              push(Scaffold(appBar: AppBar(title: Text(path))));
              // I can use setting's value here!!!
              return null;
            }),
          };
        }),
      };
    }),
  },
  errorDispatchers: {
    RouteNotFound: DeepLinkDispatcher.value((path, error, push) {
      // TODO: pop to /
      push(Scaffold(appBar: AppBar(title: Text("oopsie 404 exception"))));
      return null;
    }),
    Exception: DeepLinkDispatcher.value((path, error, push) {
      // TODO: pop to /
      push(Scaffold(appBar: AppBar(title: Text("oopsie exception"))));
      return null;
    }),
    /// TODO: use this as the main onboarding tool; set default page to something requiring authentication
    Unauthenticated: DeepLinkDispatcher((path, push) {
      // TODO: pop to /
      push(Scaffold(appBar: AppBar(title: Text("onboarding !!!"))));
      return null;
    }),
    // TODO: CantBeAnonymous exception catch (don't pop to /, just stop there at push error on top)
    // TODO: make a DeepLinkError class, one implementable field: shouldPopToRoot (this one only one with false), make custom exceptions extend this class!
  });
}