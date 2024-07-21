import 'package:flutter/material.dart';
import 'package:local/models/cart_item.dart';
import 'package:local/models/product_by_company_response.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  int? _currentCompanyId;

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + (double.parse(item.product.price) * item.quantity));

  int? get currentCompanyId => _currentCompanyId;

  void addItem(ProductByCompanyResponse product, int quantity) {
    if (_currentCompanyId != null && _currentCompanyId != product.companyId) {
      // Si el carrito tiene productos de otro proveedor, no permitir agregar
      return;
    }

    _currentCompanyId = product.companyId;

    // Si el producto ya está en el carrito, actualiza la cantidad
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity += quantity;
        notifyListeners();
        return;
      }
    }

    // Si el producto no está en el carrito, añádelo
    _items.add(CartItem(product: product, quantity: quantity));
    notifyListeners();
  }

  void removeItem(ProductByCompanyResponse product) {
    _items.removeWhere((item) => item.product.id == product.id);
    if (_items.isEmpty) {
      _currentCompanyId = null;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _currentCompanyId = null;
    notifyListeners();
  }
}
