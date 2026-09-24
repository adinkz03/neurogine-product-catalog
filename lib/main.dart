import 'package:flutter/material.dart';
import 'data/repositories/product_repository.dart';
import 'presentation/providers/product_provider.dart';
import 'presentation/screens/product_list_screen.dart';

void main() {
  final productRepository = ProductRepository();
  final productProvider = ProductProvider(repository: productRepository);

  runApp(MyApp(productProvider: productProvider));
}

class MyApp extends StatelessWidget {
  final ProductProvider productProvider;

  const MyApp({super.key, required this.productProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductListScreen(provider: productProvider),
    );
  }
}
