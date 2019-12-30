## Examples
### [Single base route](https://github.com/Dennis-Krasnov/Flutter-Deep-Link-Navigation/tree/master/examples/single_base_route)
**This example demonstrates:**
* Dispatchers with path-only deep links
* Dispatchers with value deep links (ArtistDL, SongDL)
* Cross-branch navigation (from favorite's song page to artist page)
![Navigation diagram for multiple base routes example](examples/single_base_route/navigation.png)

### [Multiple base routes](https://github.com/Dennis-Krasnov/Flutter-Deep-Link-Navigation/tree/master/examples/multiple_base_routes)
**This example demonstrates:**
* Everything from single base route example
* Bottom navigation (library, favorites, user pages) persists across navigation
* Login and error pages are full screen (hide bottom navigation)
* Using the future result of push in user/authentication page
* Custom `Authenticated` mixin ensures user is authenticated (LibraryDL, FavoritesDL, UserDL)
![Navigation diagram for multiple base routes example](examples/multiple_base_routes/navigation.png)