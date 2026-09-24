import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/state_widgets.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final ProductProvider provider;

  const ProductListScreen({super.key, required this.provider});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.provider.loadInitialProducts();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.provider.fetchMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.provider,
      builder: (context, _) {
        final provider = widget.provider;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Product Catalog'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.onSearchChanged('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) {
                    provider.onSearchChanged(val);
                  },
                ),
              ),
            ),
          ),
          body: _buildBody(provider),
        );
      },
    );
  }

  Widget _buildBody(ProductProvider provider) {
    switch (provider.state) {
      case ViewState.loading:
        return const LoadingStateWidget();
      case ViewState.empty:
        return const EmptyStateWidget();
      case ViewState.error:
        return ErrorStateWidget(
          errorMessage: provider.errorMessage,
          onRetry: () => provider.loadInitialProducts(),
        );
      case ViewState.success:
      case ViewState.initial:
        return RefreshIndicator(
          onRefresh: () => provider.loadInitialProducts(),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: provider.products.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.products.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final product = provider.products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  );
                },
              );
            },
          ),
        );
    }
  }
}
