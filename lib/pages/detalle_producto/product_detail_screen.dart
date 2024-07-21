import 'package:flutter/material.dart';
import 'package:local/models/product_by_company_response.dart';
import 'package:local/provider/carrito_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductByCompanyResponse product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  "https://via.placeholder.com/150",
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$${widget.product.price}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Cantidad:', style: TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) quantity--;
                    });
                  },
                  icon: Icon(Icons.remove),
                ),
                Text(quantity.toString(), style: TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (quantity < widget.product.stock) quantity++;
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                var cartProvider = Provider.of<CartProvider>(context, listen: false);
                if (cartProvider.currentCompanyId != null &&
                    cartProvider.currentCompanyId != widget.product.companyId) {
                  // Mostrar un mensaje si el producto es de un proveedor diferente
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Proveedor diferente'),
                      content: Text(
                          'Ya tienes productos en el carrito de otro proveedor. Vacía el carrito antes de agregar este producto.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Agregar el producto al carrito
                  cartProvider.addItem(widget.product, quantity);
                  Navigator.pop(context); // Vuelve a la pantalla anterior después de agregar al carrito
                }
              },
              child: Text('Agregar al Carrito', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                minimumSize: Size(double.infinity, 50), // Establecer el ancho máximo
              ),
            ),
          ],
        ),
      ),
    );
  }
}
