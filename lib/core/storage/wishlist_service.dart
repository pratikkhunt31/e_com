import 'package:hive/hive.dart';

import 'hive_boxes.dart';

class WishlistService {
  final Box _wishlistBox = Hive.box(HiveBoxes.wishlist);

  bool isInWishlist(int productId) => _wishlistBox.containsKey(productId.toString());

  void addToWishlist(Map<String, dynamic> product) {
    _wishlistBox.put(product["id"].toString(), product);
  }

  void removeFromWishlist(int productId) {
    _wishlistBox.delete(productId.toString());
  }

  List<Map<String, dynamic>> getAll() {
    return _wishlistBox.values.cast<Map<String, dynamic>>().toList();
  }
}