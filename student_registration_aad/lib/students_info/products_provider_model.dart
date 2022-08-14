import 'package:flutter/foundation.dart';

import '../model/product.dart';

class ProductsProviderModel extends ChangeNotifier {
  List<Product> _cartProductsList = [];
  get cartProductsList => _cartProductsList;
  get cartLength => _cartProductsList.length;
  void addToCart(Product product) {
    _cartProductsList.add(product);
    print("Cart: $_cartProductsList");
    notifyListeners();
  }

  void clearCart() {
    _cartProductsList.clear();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartProductsList
        .removeWhere((pr) => pr.productCode == product.productCode);
    notifyListeners();
  }

  void removeFromCartAt(int index) {
    _cartProductsList.removeAt(index);
    notifyListeners();
  }
}
