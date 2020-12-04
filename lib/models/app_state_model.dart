import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show compute;

import 'package:Bra7tk/models/category.dart';
import 'package:Bra7tk/models/product.dart';
import 'package:Bra7tk/services/api_stuff.dart';


// Global function to use in "compute".
Map<String, dynamic> parseJson(Map<String, dynamic> response)  {
    final List<dynamic> productsList = response['Products']['data'];
    final List<dynamic> categoriesList = response['categories'];

    final List<Category> categories = categoriesList
        .map((categoryMap) => Category.fromMap(categoryMap))
        .toList();
   
    final List<Product> products = productsList
        .map((productMap) => Product.fromJson(productMap))
        .toList();
    
    return {
      'categories': categories,
      'products': products,
    };
  }


class AppStateModel with ChangeNotifier {
  // All the available products.
  List<Product> _availableProducts;
  /// products with offers
  List<Product> _offers;
  /// availavle categories
  List<Category> _availableCategories;

  double _shippingCost = 0.0;
  double couponDiscount = 0.0;
  /// For suring not Doubling the requests, 
  /// you should request the products if only [requestingProducts] is false.
  bool requestingProducts = false;


  // The IDs and quantities of products currently in the cart.
  final Map<int, int> _productsInCart = <int, int>{};

  Map<int, int> get productsInCart => Map<int, int>.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity =>
      _productsInCart.values.fold(0, (int v, int e) => v + e);

  List<Product> get featuredProducts =>
      _availableProducts?.where((p) => p.featured)?.toList() ?? [];

  List<Product> get products => _availableProducts;
  List<Category> get availableCategories => _availableCategories;
  List<Product> get offers => _offers;
  List<Product> getProductsByCategory(Category c) =>
      _availableProducts?.where((p) => p.categoryId == c.id)?.toList() ?? [];


  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys.map((int id) {
      return getProductById(id).price * _productsInCart[id];
    }).fold(0.0, (double sum, double e) => sum + e);
  }

  double get shippingCost => _shippingCost;

  set shippingCost(double val) {
    _shippingCost = val;
    notifyListeners();
  }


  /// Total cost to order everything in the cart.
  /// note that [couponDiscount] is negative
  double get totalCost =>
      subtotalCost + couponDiscount + _shippingCost; 


  /// Adds a product to the cart.
  void addProductToCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      _productsInCart[productId]++;
    } else {
      _productsInCart[productId] = 1;
    }
    notifyListeners();
  }

  /// Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }
    notifyListeners();
  }

  /// Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts?.firstWhere((Product p) => p.id == id);
  }

  /// Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }
  

  /// Loads the list of available products from the api.
  void loadProducts() async {
    try {
      requestingProducts = true;
      var response = await ApiService().getAllProducts();

      if (response != null) {
        compute(parseJson, response)
        .then((value){
          _availableProducts = value['products'] ;
          print(_availableProducts);
          _availableCategories = value['categories'] ;
          print(_availableCategories);
          notifyListeners();
        });
      }
    } 
    catch (e) {
      print(e.toString());
    } 
    finally {
      requestingProducts = false;
      notifyListeners();
    }
  }

  void loadOffers() async {
    try {
      var response = await ApiService().getOffers();

      if (response != null) {
        _offers = response.map((e) => Product.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

  
  @override
  String toString() {
    return 'AppStateModel(totalCost: $totalCost)';
  }
}
