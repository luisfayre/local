// To parse this JSON data, do
//
//     final companyResponse = companyResponseFromJson(jsonString);

import 'dart:convert';

List<CompanyResponse> companyResponseFromJson(String str) =>
    List<CompanyResponse>.from(json.decode(str).map((x) => CompanyResponse.fromJson(x)));

String companyResponseToJson(List<CompanyResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompanyResponse {
  final int id;
  final String name;
  final String address;
  final String phone;

  CompanyResponse({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) => CompanyResponse(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
      };
}
