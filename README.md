# Flutter Deep Link Navigation

Provides an elegant abstraction for complete deep linking navigation in flutter.

Orchestrates a native flutter navigator in the background.

## Getting Started
Please refer to the examples folder.

## Features
* `DeepLinkNavigator` mirrors native `Navigator` interface, also accessible through context
* `DeepLinkNavigator.navigateTo` navigates to *ANY* route in the hierarchy
* Doesn't interfere with native dialogs, selects, and popups
* Custom mixins add provide custom logic on a deep link basis (see multiple_base_routes example)
* Animates transitions between routes as if navigation was done natively
*
* TODO: enumarate others

## Limitations
* Can't currently define arbitrarily deep navigation hierarchies (think Spotify)
* Can't store separate persisted navigation states for a multi-base route application (think Instagram)

## What's left to do
[x] Finish UI testing single base example
[x] Animated transition for pushes
[x] Custom mixins
[x] Exception handling routes
[] Push with completer
[x] Advanced example with multiple base routes and custom mixins
[] Navigation diagrams
[] Finish UI testing multi base example
[] Fully clean up code, tests, and documentation
[] Publish dart package
[] Unit test deep link navigator logic
