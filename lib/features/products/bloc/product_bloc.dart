import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/product_model.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../../repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  // Pagination variables
  int limit = 10;
  int skip = 0;
  bool isFetching = false;

  List<Product> allProducts = [];

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FetchProductsByCategory>(_onFetchByCategory);

    on<FetchSingleProduct>(_onFetchSingleProduct);
  }

  /// Fetch products with pagination
  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    try {
      if (isFetching) return;
      isFetching = true;

      if (event.isRefresh) {
        skip = 0;
        allProducts.clear();
      }

      emit(ProductLoading());

      final products =
      await productRepository.fetchProducts(limit: limit, skip: skip);

      if (products.isEmpty && allProducts.isEmpty) {
        emit(ProductEmpty());
      } else {
        allProducts.addAll(products);
        skip += limit;

        emit(ProductLoaded(
          products: allProducts,
          hasMore: products.length == limit,
        ));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onFetchSingleProduct(
      FetchSingleProduct event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final product = await productRepository.getSingleProduct(event.productId);
      emit(ProductSingleLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  /// Search products
  Future<void> _onSearchProducts(
      SearchProducts event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final results = await productRepository.searchProducts(event.query);
      if (results.isEmpty) {
        emit(ProductEmpty());
      } else {
        emit(ProductLoaded(products: results, hasMore: false));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  /// Fetch products by category
  Future<void> _onFetchByCategory(
      FetchProductsByCategory event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final results = await productRepository.fetchProductsByCategory(event.category);
      if (results.isEmpty) {
        emit(ProductEmpty());
      } else {
        emit(ProductLoaded(products: results, hasMore: false));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

}

