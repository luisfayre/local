import 'package:local/models/product_by_company_response.dart';

class CartItem {
  final ProductByCompanyResponse product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
