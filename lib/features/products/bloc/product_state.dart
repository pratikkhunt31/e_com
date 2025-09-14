import 'package:equatable/equatable.dart';

import '../data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProductInitial extends ProductState {}

/// Loading state
class ProductLoading extends ProductState {}

/// Loaded state
class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore; // for pagination

  const ProductLoaded({required this.products, this.hasMore = true});

  @override
  List<Object?> get props => [products, hasMore];
}

class ProductSingleLoaded extends ProductState {
  final Product product;

  const ProductSingleLoaded(this.product);
}

/// Error state
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state
class ProductEmpty extends ProductState {}
