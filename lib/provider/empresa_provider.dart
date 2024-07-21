import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local/models/cart_item.dart';
import 'package:local/models/company_response.dart';
import 'package:local/models/product_by_company_response.dart';

class CompanyProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  List<CompanyResponse> _companies = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<CompanyResponse> get companies => _companies;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCompanies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _companies = await _apiService.fetchCompanies();
    } catch (error) {
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}

class ApiService {
  static const String _baseUrl = 'http://192.168.100.5:8000/api/v1';

  Future<List<CompanyResponse>> fetchCompanies() async {
    final response = await http.get(Uri.parse('$_baseUrl/companies'));

    if (response.statusCode == 200) {
      return companyResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<List<ProductByCompanyResponse>> fetchProductsByCompany(int companyId) async {
    final response = await http.get(Uri.parse('$_baseUrl/companies/$companyId/products'));

    if (response.statusCode == 200) {
      return productByCompanyResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> createOrder(int companyId, List<CartItem> items, double totalPrice) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNzAwNDcwMWIxYmQ3YTIwZTllNjdkYzhlZmFlNzI2ZTE5MGYxYWQ2MTU5OGViMmMzZDllYTAxYjIyN2YyNTA3Njg4NGViNjZiY2FhMDg4YTgiLCJpYXQiOjE3MjE1MzMwODUuMjk3NzgyLCJuYmYiOjE3MjE1MzMwODUuMjk3Nzg0LCJleHAiOjE3NTMwNjkwODUuMjkwMjk2LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.IFKDsmamULIQh1EmWlVELgTjrjmQbntBMeIA9a0d9NKah_8RtpXZ-0huFvZ2YiBVMa3cLQo2C8Lwn76KwzyBoHzj92XqSg70Xi7O5S1qxtXOuCJYxnMf6FJW_sYPgzoTXOtgZsUIf_FjLHu1FcpbmjUZSIZH9p4Gn7NtkbVS-I17XmB60QT8SYpm_iL-aFY2c71_LcvTB-_xHOgwyMpG8YsQdNCbArcb8kGkRFLfq16mEzVCSo0HVqWO45Xn3vtXa6QJMDiKGYhv8EcuKR-G8RKIbdhU5vluApMwfx0or12E2JcbHipdxKsKckzr4FgE6XOcriDXJr0yVaabwftrsdPqMg0e-NR88A2Q5lAKfCjrctxB6VRU1R7MUpxrqO3AOufXu3b52lqU-NeMZUTahSpmqIUt_y3FxljUykYUF1Y6no3UJ0Z4dJodN4_AjxQTxYtDgVm-Ja48VGP7jBJQecCJbpSjiCVasL2s57XyREKAmqkVoswUM_fjJNSceQwj5LE_OVoYkF4fTyCN6vQ4HhJad6ovv3UM_KbcEZdWn9tgrN2ZoERgD8PPqdj8u3TVzrhtfQXeyclpDU-wk3D7zdUzgpMkoayd6hqWIvarhZ6t_b67WRNBSKlxNJJcW3HJ_FrPn3Jc2lAe5uBhoFOMLxhGZRZaod7la1O2yF7PYTk',
      },
      body: jsonEncode({
        'company_id': companyId,
        'items': items
            .map((item) => {
                  'product_id': item.product.id,
                  'quantity': item.quantity,
                  'price': item.product.price,
                })
            .toList(),
        'total_price': totalPrice,
      }),
    );

    print(response.body);

    if (response.statusCode == 201) {
      print('Order created successfully');
    } else {
      throw Exception('Failed to create order');
    }
  }
}
