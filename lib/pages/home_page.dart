import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../state/cart_state.dart';
import '../state/wishlist_state.dart';
import '../components/banner_slider.dart';
import '../components/product_card.dart';
import '../components/category_slider.dart';
import '../components/product_row_slider.dart';
import '../components/section_header.dart';
import 'cart_page.dart';
import 'product_details.dart';
import 'wishlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _allProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';
  int _bottomNavIndex = 0;

  List<String> get _categories {
    final cats = _allProducts.map((p) => p.category).toSet().toList()..sort();
    return ['all', ...cats];
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'all') return _allProducts;
    return _allProducts.where((p) => p.category == _selectedCategory).toList();
  }

  List<Product> get _topRatedProducts {
    final sorted = [..._allProducts]..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(10).toList();
  }

  List<Product> get _featuredProducts {
    return _allProducts.take(8).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products?limit=30'));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['products'] ?? decoded;
        setState(() {
          _allProducts = data.map((item) => Product.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Network Error: $e");
    }
  }

  void _openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(
          product: product,
          onAddToCart: () => setState(() {}),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: [
          _buildHomeBody(),
          WishlistPage(onChanged: _refresh),
          CartPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => setState(() => _bottomNavIndex = i),
        selectedItemColor: const Color(0xFF2874F0),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Stack(children: [
              const Icon(Icons.favorite_border),
              if (globalWishlist.isNotEmpty)
                Positioned(right: 0, top: 0, child: Container(
                  width: 14, height: 14,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Center(child: Text(globalWishlist.length.toString(), style: const TextStyle(color: Colors.white, fontSize: 9))),
                )),
            ]),
            activeIcon: const Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Stack(children: [
              const Icon(Icons.shopping_cart_outlined),
              if (globalCart.isNotEmpty)
                Positioned(right: 0, top: 0, child: Container(
                  width: 14, height: 14,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Center(child: Text(globalCart.length.toString(), style: const TextStyle(color: Colors.white, fontSize: 9))),
                )),
            ]),
            activeIcon: const Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
      ),
    );
  }

  Widget _buildHomeBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          pinned: true,
          floating: true,
          backgroundColor: const Color(0xFF2874F0),
          title: Container(
            height: 38,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                const SizedBox(width: 6),
                Text("Search for products...", style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2874F0)))
          : _allProducts.isEmpty
          ? _buildErrorState()
          : RefreshIndicator(
        onRefresh: _fetchProducts,
        color: const Color(0xFF2874F0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // Banner Slider
        const BannerSlider(),
        const SizedBox(height: 8),

        // Category Slider
        SectionHeader(title: "Shop by Category"),
        CategorySlider(
          categories: _categories,
          selected: _selectedCategory,
          onSelected: (cat) => setState(() => _selectedCategory = cat),
        ),

        // Top Rated / Highlighted Products
        SectionHeader(
          title: "Top Rated",
          subtitle: "Highest rated products",
          onSeeAll: () {},
        ),
        ProductRowSlider(
          products: _topRatedProducts,
          onProductTap: _openProduct,
          onCartChanged: _refresh,
        ),

        // Featured Products
        SectionHeader(
          title: "Featured Products",
          subtitle: "Handpicked for you",
          onSeeAll: () {},
        ),
        ProductRowSlider(
          products: _featuredProducts,
          onProductTap: _openProduct,
          onCartChanged: _refresh,
        ),

        // Filtered / All Products Grid
        SectionHeader(
          title: _selectedCategory == 'all' ? "All Products" : _selectedCategory.split('-').map((w) => w[0].toUpperCase() + w.substring(1)).join(' '),
          subtitle: "${_filteredProducts.length} items",
        ),
        _buildProductGrid(),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          onTap: () => _openProduct(products[index]),
          onAdd: () {
            CartLogic.addToCart(products[index]);
            _refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${products[index].name} added to cart!"),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          onWishlistChanged: _refresh,
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
          const SizedBox(height: 10),
          const Text("No internet or server error", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchProducts,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2874F0), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
