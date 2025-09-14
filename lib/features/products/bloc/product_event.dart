import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Load products (initial or pagination)
class FetchProducts extends ProductEvent {
  final bool isRefresh;

  const FetchProducts({this.isRefresh = false});
}

/// Search products
class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);
}

/// Load products by category
class FetchProductsByCategory extends ProductEvent {
  final String category;

  const FetchProductsByCategory(this.category);
}

class FetchSingleProduct extends ProductEvent {
  final int productId;

  const FetchSingleProduct(this.productId);
}