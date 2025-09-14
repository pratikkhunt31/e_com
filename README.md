## Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/pratikkhunt31/e_com.git

flutter pub get

await Hive.initFlutter();
await Hive.openBox('settings');
await Hive.openBox('cart');
await Hive.openBox('wishlist');
await Hive.openBox('cacheProducts');

flutter run

Overview:-
Flutter-based e-commerce app featuring:
User authentication (login, register, logout) with Hive session persistence.
Product listing with pagination, category filter, and search.
Product detail view with reviews and related products.
Cart management with add/remove items and total price calculation.

Architecture & Approach:-
State Management: GetX for authentication, BLoC for products.
Persistence: Hive for storing session, cart, wishlist, and cached products.
Networking: http package for API communication with DummyJSON endpoints.
UI: Responsive, Grid/List views for products; modular screens (Home, Product Detail, Cart).

Design Decisions:-
BLoC separates business logic from UI for scalability.
Hive chosen for lightweight local storage and offline support.
GetX simplifies routing, dependency injection, and state management for auth flows.
