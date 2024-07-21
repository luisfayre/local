// To parse this JSON data, do
//
//     final productByCompanyResponse = productByCompanyResponseFromJson(jsonString);

import 'dart:convert';

List<ProductByCompanyResponse> productByCompanyResponseFromJson(String str) =>
    List<ProductByCompanyResponse>.from(json.decode(str).map((x) => ProductByCompanyResponse.fromJson(x)));

String productByCompanyResponseToJson(List<ProductByCompanyResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductByCompanyResponse {
  final int id;
  final int companyId;
  final String name;
  final String description;
  final String price;
  final int stock;
  final String image;

  ProductByCompanyResponse({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory ProductByCompanyResponse.fromJson(Map<String, dynamic> json) => ProductByCompanyResponse(
        id: json["id"],
        companyId: json["company_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        stock: json["stock"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "image": image,
      };
}
