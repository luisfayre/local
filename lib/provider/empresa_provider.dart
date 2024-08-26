import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local/models/cart_item.dart';
import 'package:local/models/categoria_response.dart';
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
  static const String _baseUrl = 'http://10.1.10.9:8000/api/v1';

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

  Future<List<CategoriaResponse>> getCategorias(int companyId) async {
    final response = await http.get(Uri.parse('$_baseUrl/companies/$companyId/categorias'));
    if (response.statusCode == 200) {
      return categoriaResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load categorias');
    }
  }

  Future<void> createOrder(int companyId, List<CartItem> items, double totalPrice) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDZmYzZmMDZiNGQyNTQwMTJiNjk3Y2NiM2IxOTA4Y2Q1ODIxZGY0NmIzYjcwMzkxZjM2NzRiMDIxYzg4ZGUxZjBlMTczMWQ0MTk4NjRhNWIiLCJpYXQiOjE3MjI4NzYxMTUuNzI3NzkzLCJuYmYiOjE3MjI4NzYxMTUuNzI3Nzk0LCJleHAiOjE3NTQ0MTIxMTUuNzI0NjM2LCJzdWIiOiI0Iiwic2NvcGVzIjpbXX0.mPyuvmrI71xLd9tBGRwsCaFp3gPxZkogkCpQXzNiCYk4GKN0tgy5o-5_rQ5nwPK5Z7kTHYuhbwm8A6K07uyd-xLwigYXfFClS0WckGVCOGF6cZ4jPUzQZ-CaKDB9TV9L-ybn5itfbT1AqMV94e8Ezzzyi8lOQdqlMKvSxC6R-BozGNBiVxIBUraDo7kTeBc44gc5FY5nV9jtqxT-8yf48033bO_kOVDGHGzZhh9bMWUYwoLb7wUKFIIAKgCErAMnd3uetSP1LRcbZ_joiTDkM2o3amH4oRf5SKmlWIlodlc9foCtHdJC1fa8bmFMAz3nyiHHZyI3mvS6NjSedS1rkanrxK_oikB6EWtMvik5KafNoLDmMd4roDaxXNqYdRHSK7R_Qb3lW_iRabWzUmKKuWVY-1fd4F3afhXaLM_WpTq1xSqvP1Q7DMQuksNYfo4xrUUge2WO18U_2qW7tZ1K42bArnR4TlZUowrk7WlZoBdUq7SyYqTXpkEqhLQtdMHbcl7l-6828RJA-ETN1FDnJJwdSnl-gUrw7WEHPwmU11okyn45X8n1m90tBnSzn0RUOzrUfyyBYLsu9nK56kVn1agVbaG_Am74W6wlUmmcP7DOdJ_SdMGzWveUAnZF8LEhQmckfnr6zg3AvR8gNGGEE-rP2wUFR_w97LIGQvtBLRo',
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
