# Product Catalog App — Technical Assessment

A responsive Flutter mobile application built for the Neurogine Junior Mobile Developer technical assessment using the free [DummyJSON API](https://dummyjson.com).

## 📱 Features & Requirements Coverage

### Core Features

- **Product Catalog Listing:** Itemized list displaying product thumbnail, title, rating, and price.
- **Lazy Loading Pagination:** Incrementally fetches products in batches using the `skip` parameter (`?limit=20&skip=X`).
- **Product Detail Screen:** Comprehensive view featuring full description, price, rating, and horizontal image gallery.
- **Explicit State Machine:** Clear UI representation for `Loading`, `Error` (with an interactive **Retry** button), `Empty`, and `Success` states.
- **Debounced Server Search:** Real-time search using `/products/search?q=` with a 500ms debounce buffer to minimize unnecessary API requests.

### Bonus Capabilities

- **Pull-to-Refresh:** Interactive list refresh utilizing Flutter's `RefreshIndicator`.
- **Image Caching & Fallbacks:** Network image caching via `cached_network_image` with custom loading placeholders and broken image error widgets.
- **Unit Testing:** Automated unit testing for repository API calls using `mockito`.

## 🏗️ Architectural Overview

The application follows Clean Architecture principles divided into three distinct layers:

1. **Data Layer (`lib/data/`)**
   - `Product` and `ProductResponse` JSON serialization models.
   - `ProductRepository` network client encapsulating REST API interaction using `http.Client`.

2. **Domain / State Layer (`lib/presentation/providers/`)**
   - `ProductProvider` (`ChangeNotifier`) handling reactive state transitions via an explicit `ViewState` enum, search debouncing logic, and scroll pagination tracking.

3. **Presentation Layer (`lib/presentation/`)**
   - Modular screens (`ProductListScreen`, `ProductDetailScreen`).
   - Reusable UI state components (`LoadingStateWidget`, `ErrorStateWidget`, `EmptyStateWidget`, `ProductCard`).

### Search Architecture Decision

Server-side search (`/products/search?q=`) paired with a **500ms client-side debounce timer** was selected over client-side filtering.

**Reasoning:** Querying the server guarantees complete search coverage across the entire remote database instead of limiting searches to items currently loaded in memory. The 500ms debounce protects network bandwidth and server resources by only triggering a request once the user pauses typing.

## 🛠️ How to Build and Run

1. **Clone the repository**

   ```bash
   git clone https://github.com/adinkz03/neurogine-product-catalog.git
   cd neurogine-product-catalog
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run unit tests**

   ```bash
   flutter test
   ```

4. **Launch the application**

   ```bash
   flutter run
   ```

## 🤖 AI Usage Disclosure

In compliance with assessment instructions:

- **Core Architecture & Logic:** The clean directory structure, state transition workflow (`ViewState`), pagination mechanics, debouncing implementation, and state widget patterns were engineered manually.
- **AI Assistance:** AI was utilized for quick environment setup diagnostic troubleshooting and boilerplate code generation for model parsing structures and unit test mock generation.

## 📝 TODOs & Future Enhancements

- [ ] Implement category filter chips on the catalog screen.