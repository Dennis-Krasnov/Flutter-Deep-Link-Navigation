## [1.3.1] - 2019/12/09

* Breaking change: Changed path (string) to route (List<DeepLink>) in configuration
* Breaking change: navigation and subNavigation no longer takes context as argument, no function for path
* Updated documentation and examples

## [1.2.1] - 2019/11/16

* Removed context from exception mapping

## [1.1.1] - 2019/11/15

* Updated configuration syntax to allow passing value deeper in hierarchy
* Added a future<T> return for DeepLinkNavigator.push<T>
* Added promise route for multi_base_routes example, added to UI test
* Refactored and documented project
* Added readme documentation with diagrams and examples

## [1.0.1] - 2019/11/14

* Completely overhauled configuration syntax
* Simplified deep link processing logic
* Generalized exception handling by mapping exceptions to routes
* Remove unnecessary exception dispatchers
* Updated examples with new configuration syntax
* Fixed examples' deep link typing
* Checked in multiple_base_route example configuration files

## [0.1.2] - 2019/11/06

* Made defaultRoute field optional

## [0.1.1] - 2019/11/02

* Initial release
