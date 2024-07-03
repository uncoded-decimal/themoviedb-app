A flutter project implementing [themoviedb](https://www.themoviedb.org/) APIs using bloc.

## Plugins and Packages used

1. [flutter_bloc](https://pub.dev/packages/flutter_bloc):

   Used for the basic implementation of BLoC architecture.

2. [equatable](https://pub.dev/packages/equatable):

   Comparision between multiple instances of Events and States is performed throught the `props` list provided by this package.

3. [geolocator](https://pub.dev/packages/geolocator):

   Provides access to the on-device location APIs, allowing managing Location Permission and Service.

4. [geocoding](https://pub.dev/packages/geocoding):

   Uses on-device APIs to perform easy geocoding and reverse-geocoding.

5. [dio](https://pub.dev/packages/dio):

   HTTP networking client to perform API calls.

6. [hive](https://pub.dev/packages/hive):

   Local Database plugin. Uses `Box`es for data storage.

7. [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager):

   Provides a cache manager used to Pre-Cache images.

8. Other Packages:

   [flutter_svg](https://pub.dev/packages/flutter_svg), [google_fonts](https://pub.dev/packages/google_fonts), [cached_network_image](https://pub.dev/packages/cached_network_image) and [shimmer](https://pub.dev/packages/shimmer) are used to help develop the App UI.

   

## Notable Classes

1. __LoggingIngterceptor__:

   Works with Dio HTTP client to log API calls' Request and Responses for Easy Debugging.
   
2. __DotsIndicator__:

   Works in conjunction with Now Playing movies list to display a page and index indicator.

3. __NowPlayingClipper__:

   Uses a `Path` to clip it's child to draw a fancy shape.



## Useful Techniques 

1. Performed an auto scroll after each page fetched for Now Playing section. This helped refresh the `DotsIndicator` state to display the correct digits while also providing for a good UX.
2. Pre-caching the first 2 images from Now Playing and Top Rated API Call responses for a smooth loading experience going into Home screen. 2 for each API because the first visible tiles for each List would be the first 2 elements.
3. Opened a `Hive` Box soon as the app launches so Local Database can be accessed without any delays of operation.
4. [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) for generating Launcher Icons.
