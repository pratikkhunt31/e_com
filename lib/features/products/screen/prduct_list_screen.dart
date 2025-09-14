import 'package:e_com/features/products/screen/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/storage/wishlist_service.dart';
import '../../../repositories/product_repository.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../data/models/product_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductBloc productBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    productBloc = ProductBloc(productRepository: ProductRepository());
    productBloc.add(const FetchProducts());

    // Pagination scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          productBloc.state is ProductLoaded &&
          (productBloc.state as ProductLoaded).hasMore) {
        productBloc.add(const FetchProducts());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    productBloc.close();
    super.dispose();
  }

  Future<void> _refreshProducts() async {
    productBloc.add(const FetchProducts(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        bloc: productBloc,
        builder: (context, state) {
          if (state is ProductLoading && productBloc.allProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is ProductEmpty) {
            return const Center(child: Text("No products found"));
          } else if (state is ProductLoaded ||
              productBloc.allProducts.isNotEmpty) {
            final products = productBloc.allProducts;

            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size.width > 600 ? 3 : 2,
                  // responsive columns
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: products.length + 1,
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    final product = products[index];
                    return InkWell(
                      onTap: () {
                        // Navigate to Product Detail Screen with productId
                        Get.to(
                            () => ProductDetailScreen(productId: product.id));
                      },
                      child: ProductCard(product: product),
                    );
                  } else {
                    // Loader at bottom for pagination
                    return productBloc.state is ProductLoaded &&
                            (productBloc.state as ProductLoaded).hasMore
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox();
                  }
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final WishlistService wishlistService = WishlistService();

  ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isInWishlist = wishlistService.isInWishlist(product.id);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                    color: isInWishlist ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (isInWishlist) {
                      wishlistService.removeFromWishlist(product.id);
                    } else {
                      wishlistService.addToWishlist({
                        "id": product.id,
                        "title": product.title,
                        "price": product.price,
                        "thumbnail": product.thumbnail
                      });
                    }
                    (context as Element).markNeedsBuild(); // refresh widget
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text("\$${product.price.toStringAsFixed(2)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}