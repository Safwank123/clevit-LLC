1. google_fonts: ^6.2.1
Purpose: Provides easy access to 1,500+ open-source fonts from Google Fonts

Why You Need It:

Consistent typography across your app

No need to manually download font files

Dynamic font loading (reduces app size)

Used in your UI for text styling (like GoogleFonts.ebGaramond())

2. bloc: ^9.0.0 + flutter_bloc: ^9.1.1
Purpose: State management solution (Business Logic Component pattern)

Why You Need It:

Manages complex state in your whisky collection

Separates business logic from UI

Handles loading/error states for bottle data

Provides BlocBuilder, BlocProvider, etc. widgets

Used in your BottleBloc for managing bottle data

3. equatable: ^2.0.7
Purpose: Simplifies value-based equality comparisons

Why You Need It:

Essential for BLoC state comparisons

Reduces boilerplate code for == and hashCode

Used in your BottleState and BottleEvent classes

Prevents unnecessary widget rebuilds

4. connectivity_plus: ^6.1.4
Purpose: Network connectivity status monitoring

Why You Need It:

Detect when users go offline/online

Show appropriate UI messages

Cache data when offline

Future-proof if you add API calls

5. shared_preferences: ^2.5.3
Purpose: Persistent local storage for simple data

Why You Need It:

Store user preferences (theme, sort order)

Remember last viewed bottles

Simple key-value storage (uses platform-native storage)

6. cached_network_image: ^3.4.1
Purpose: Efficient image loading with caching

Why You Need It:

Cache bottle images for offline viewing

Progressive loading (placeholders → low-res → high-res)

Memory/disk caching (better performance)

Used if you load bottle images from URLs

7. go_router: ^15.2.0
Purpose: Declarative routing/navigation

Why You Need It:

Deep linking support (e.g., /bottle/2504)

Clean navigation logic

Better than Navigator 2.0 boilerplate

Used for your /bottle detail screen navigation

8. get_it: ^8.0.3
Purpose: Service locator (dependency injection)

Why You Need It:

Manage dependencies like BLoCs, repositories

Easy access to services anywhere in app

Alternative to passing objects through widgets

Used to access your BottleBloc globally

9. hive: ^2.2.3 + hive_flutter: ^1.1.0
Purpose: Lightweight NoSQL local database

Why You Need It:

Persistent storage for bottle collection

Faster than SQLite for simple objects

Store user's whisky collection offline

Can cache API responses

Used if you need complex local data storage

10. path_provider: ^2.1.5
Purpose: Finds filesystem paths on iOS/Android

Why You Need It:

Required by Hive to find database location

Gets app documents/temporary directories

Used for storing persistent Hive data

11. focus_detector: ^2.0.1
Purpose: Detects when screens gain/lose focus


