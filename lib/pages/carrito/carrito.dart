import 'package:flutter/material.dart';
import 'package:local/provider/carrito_provider.dart';
import 'package:local/provider/empresa_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrito')),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.items[index];
                    return ListTile(
                      title: Text(cartItem.product.name),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              cartProvider.decreaseQuantity(cartItem.product);
                            },
                          ),
                          Text('Cantidad: ${cartItem.quantity}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              cartProvider.increaseQuantity(cartItem.product);
                            },
                          ),
                        ],
                      ),
                      trailing:
                          Text('\$${(double.parse(cartItem.product.price) * cartItem.quantity).toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      int? companyId =
                          cartProvider.items.isNotEmpty ? cartProvider.items.first.product.companyId : null;
                      if (companyId != null) {
                        await apiService.createOrder(companyId, cartProvider.items, cartProvider.totalPrice);
                        // Limpiar el carrito después de realizar el pedido
                        cartProvider.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Pedido realizado con éxito')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: No se pudo determinar la compañía')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al realizar el pedido')),
                      );
                    }
                  },
                  child: Text('Realizar Pedido', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
