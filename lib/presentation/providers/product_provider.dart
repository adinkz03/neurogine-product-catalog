import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';

enum ViewState { initial, loading, success, empty, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider({required this.repository});

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  List<Product> _products = [];
  List<Product> get products => _products;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;

  int _skip = 0;
  final int _limit = 20;
  String _currentQuery = '';

  Timer? _debounce;

  Future<void> loadInitialProducts() async {
    _state = ViewState.loading;
    _skip = 0;
    _hasMore = true;
    _currentQuery = '';
    notifyListeners();

    try {
      final response = await repository.fetchProducts(limit: _limit, skip: 0);
      _products = response.products;
      _skip = response.products.length;

      if (_products.isEmpty) {
        _state = ViewState.empty;
      } else {
        _hasMore = _products.length < response.total;
        _state = ViewState.success;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> fetchMoreProducts() async {
    if (!_hasMore ||
        _isFetchingMore ||
        _state == ViewState.loading ||
        _currentQuery.isNotEmpty) {
      return;
    }

    _isFetchingMore = true;
    notifyListeners();

    try {
      final response = await repository.fetchProducts(
        limit: _limit,
        skip: _skip,
      );
      _products.addAll(response.products);
      _skip += response.products.length;
      _hasMore = _products.length < response.total;
    } catch (e) {
      // Keep existing list on pagination error
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query.trim());
    });
  }

  Future<void> _search(String query) async {
    _currentQuery = query;
    if (query.isEmpty) {
      await loadInitialProducts();
      return;
    }

    _state = ViewState.loading;
    notifyListeners();

    try {
      final response = await repository.searchProducts(query);
      _products = response.products;
      _hasMore = false; // Search endpoint returns all matched items

      if (_products.isEmpty) {
        _state = ViewState.empty;
      } else {
        _state = ViewState.success;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
