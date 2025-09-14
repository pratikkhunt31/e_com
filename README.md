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


<img width="1440" height="3120" alt="Screenshot_20250914_184621" src="https://github.com/user-attachments/assets/c948a32b-7b54-46a2-8717-892906dfba59" />
<img width="1440" height="3120" alt="Screenshot_20250914_184557" src="https://github.com/user-attachments/assets/517b77b3-d940-4caf-a9eb-b88590d33b5b" />
<img width="1440" height="3120" alt="Screenshot_20250914_184431" src="https://github.com/user-attachments/assets/9ebf958f-9425-4954-9d50-d6a2510ea042" />
<img width="1440" height="3120" alt="Screenshot_20250914_184448" src="https://github.com/user-attachments/assets/3ce1c5c9-b8d9-4968-a5a3-843db3496e9b" />
<img width="1440" height="3120" alt="Screenshot_20250914_184502" src="https://github.com/user-attachments/assets/86e6568f-1449-4f6d-9e91-87bb85cac509" />
<img width="1440" height="3120" alt="Screenshot_20250914_184545" src="https://github.com/user-attachments/assets/809b2661-1ca7-4a6c-a43a-c085706261dc" />

