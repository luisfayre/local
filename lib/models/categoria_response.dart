import 'dart:convert';

List<CategoriaResponse> categoriaResponseFromJson(String str) => List<CategoriaResponse>.from(json.decode(str).map((x) => CategoriaResponse.fromJson(x)));

String categoriaResponseToJson(List<CategoriaResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriaResponse {
    final int id;
    final String categoria;
    String? image;

    CategoriaResponse({
        required this.id,
        required this.categoria,
      this.image,
    });

    factory CategoriaResponse.fromJson(Map<String, dynamic> json) => CategoriaResponse(
        id: json["id"],
        categoria: json["categoria"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "categoria": categoria,
        "image": image,
    };
}
