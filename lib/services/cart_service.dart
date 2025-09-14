
import 'package:hive/hive.dart';
import '../core/storage/hive_boxes.dart';

class CartService {
  final _cartBox = Hive.box(HiveBoxes.cart);

  /// Get all items in cart
  List<Map<String, dynamic>> getCartItems() {
    final items = _cartBox.values.cast<Map>().toList();
    return items.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Add or update item in cart
  void addToCart(Map<String, dynamic> product) {
    final id = product['id'];
    if (_cartBox.containsKey(id)) {
      final existing = Map<String, dynamic>.from(_cartBox.get(id));
      existing['quantity'] = (existing['quantity'] ?? 1) + 1;
      _cartBox.put(id, existing);
    } else {
      product['quantity'] = 1;
      _cartBox.put(id, product);
    }
  }

  /// Remove an item
  void removeFromCart(int productId) {
    _cartBox.delete(productId);
  }

  /// Clear cart
  void clearCart() {
    _cartBox.clear();
  }

  /// Total price
  double getTotalPrice() {
    double total = 0;
    for (var item in _cartBox.values) {
      final map = Map<String, dynamic>.from(item);
      total += (map['price'] ?? 0) * (map['quantity'] ?? 1);
    }
    return total;
  }
}
