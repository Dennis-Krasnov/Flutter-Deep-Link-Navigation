import 'package:deep_link_navigation/deep_link_navigation.dart';
import 'package:flutter/widgets.dart';
import 'package:single_base_route/model.dart';

/// Hide navigation for this routes and all its sub-routes.
mixin FullScreen on DeepLink {}

/// ...
mixin Authenticated on DeepLink {
  bool allowAnonymous();

  @override
  void onDispatch(BuildContext context) {
    // MIXINS GET EVALUATED LTR
    // only works if can fetch state from context (inherited widget, provider, etc)
    super.onDispatch(context);
    // throw Unauthenticated() , or other custom errors!
  }
}

/// ...
class OnboardingDL extends DeepLink {
  OnboardingDL() : super("onboarding");
}

/// ...
class BankAccountsDL extends DeepLink {
  BankAccountsDL() : super("bank-accounts");
}

/// ...
class BankAccountDetailsDL extends ValueDeepLink {
  BankAccountDetailsDL(BankAccount bankAccount) : super("account/${bankAccount.id}", bankAccount);
}

/// ...
class SettingsDL extends DeepLink with Authenticated {
  SettingsDL() : super("settings");

  @override
  bool allowAnonymous() => false;
}

/// ...
class AdvancedSettingsDL extends DeepLink with FullScreen {
  AdvancedSettingsDL() : super("advanced");
}

// DOCUMENT: MIXINS AFFECT ALL PATHS DOWN THE CHAIN (short circuits)

/// ...
class Unauthenticated implements Exception {
  @override
  String toString() => "401: User isn't authenticated";
}