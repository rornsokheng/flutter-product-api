import 'package:basic_flutter/model/product.dart';
class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _cartItems.fold(
    0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  void addToCart(Product product) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      _cartItems.add(CartItem(product: product));
    } else {
      existingItem.quantity++;
    }
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
      return;
    }
    final item = _cartItems.firstWhere((item) => item.product.id == product.id);
    item.quantity = quantity;
  }

  void clearCart() {
    _cartItems.clear();
  }
}