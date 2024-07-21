import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
}
