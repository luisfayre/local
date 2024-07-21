import 'package:flutter/material.dart';
import 'package:local/models/product_by_company_response.dart';
import 'package:local/provider/empresa_provider.dart';

class ProductProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  List<ProductByCompanyResponse> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<ProductByCompanyResponse> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchProductsByCompany(int companyId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _products = await _apiService.fetchProductsByCompany(companyId);
    } catch (error) {
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
