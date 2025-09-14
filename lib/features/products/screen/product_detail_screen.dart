import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/storage/wishlist_service.dart';
import '../../../repositories/product_repository.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../data/models/product_model.dart';
import '../../../core/storage/hive_boxes.dart';
import 'package:hive/hive.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;


  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductBloc productBloc;
  final Box cartBox = Hive.box(HiveBoxes.cart);
  late WishlistService wishlistService;
  bool isInWishlist = false;


  @override
  void initState() {
    super.initState();
    productBloc = ProductBloc(productRepository: ProductRepository());
    productBloc.add(FetchSingleProduct(widget.productId));
    wishlistService = WishlistService();
    isInWishlist = wishlistService.isInWishlist(widget.productId);
  }

  void addToCart(Product product) {
    final key = product.id.toString();
    if (cartBox.containsKey(key)) {
      // Increase quantity
      final item = cartBox.get(key);
      cartBox.put(key, {...item, "quantity": item["quantity"] + 1});
    } else {
      cartBox.put(key, {
        "id": product.id,
        "title": product.title,
        "price": product.price,
        "thumbnail": product.thumbnail,
        "quantity": 1,
      });
    }
    Get.snackbar("Success", "${product.title} added to cart");
  }

  @override
  void dispose() {
    productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Detail")),
      body: BlocBuilder<ProductBloc, ProductState>(
        bloc: productBloc,
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is ProductSingleLoaded) {
            final product = state.product;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images carousel
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemCount: product.images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          product.images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Product info
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.green),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(product.rating.toString()),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(product.description),
                        const SizedBox(height: 16),

                        // Wishlist
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => addToCart(product),
                                child: const Text("Add to Cart"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                isInWishlist ? Icons.favorite : Icons.favorite_border,
                                color: isInWishlist ? Colors.red : Colors.grey,
                                size: 28,
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
                                setState(() {}); // update icon
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Reviews
                        const Text(
                          "Reviews",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...product.reviews.map((review) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(review.reviewerName),
                              subtitle: Text(review.comment),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(review.rating.toString()),
                                ],
                              ),
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 16),

                        // Related products
                        const Text(
                          "Related Products",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        RelatedProductsSection(category: product.category),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

// Related Products Section
class RelatedProductsSection extends StatelessWidget {
  final String category;
  const RelatedProductsSection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(productRepository: ProductRepository())
        ..add(FetchProductsByCategory(category)),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is ProductLoaded) {
            final products = state.products;

            return SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      Get.to(() =>
                          ProductDetailScreen(productId: product.id));
                    },
                    child: SizedBox(
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              product.thumbnail,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                            ),
                          ),
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text("\$${product.price.toStringAsFixed(2)}"),
                        ],
                      ),
                    ),
                  );
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
