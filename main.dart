
import 'package:flutter/material.dart';

void main() {
  runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Search',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const ProductHomePage(),
    );
  }
}

class Product {
  final String name;
  final String category;
  final double price;

  const Product({
    required this.name,
    required this.category,
    required this.price,
  });
}

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({super.key});

  @override
  State<ProductHomePage> createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {
  final TextEditingController searchController =
      TextEditingController();

  String searchText = '';
  String selectedCategory = 'All';

  final List<Product> products = const [
    Product(name: 'Laptop', category: 'Electronics', price: 55000),
    Product(name: 'Mobile Phone', category: 'Electronics', price: 25000),
    Product(name: 'Headphones', category: 'Electronics', price: 2000),
    Product(name: 'T-Shirt', category: 'Clothing', price: 800),
    Product(name: 'Jeans', category: 'Clothing', price: 1500),
    Product(name: 'Shoes', category: 'Clothing', price: 3000),
    Product(name: 'Backpack', category: 'Accessories', price: 1200),
    Product(name: 'Watch', category: 'Accessories', price: 2500),
  ];

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      final matchesCategory = selectedCategory == 'All' ||
          product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayedProducts = filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShopEase - Product Search',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search products',
                hintText: 'Enter product name',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchText = '';
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Filter by category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All Categories'),
                ),
                DropdownMenuItem(
                  value: 'Electronics',
                  child: Text('Electronics'),
                ),
                DropdownMenuItem(
                  value: 'Clothing',
                  child: Text('Clothing'),
                ),
                DropdownMenuItem(
                  value: 'Accessories',
                  child: Text('Accessories'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: displayedProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: displayedProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayedProducts[index];

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Icon(
                                Icons.shopping_bag,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(product.category),
                            trailing: Text(
                              '₹${product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
