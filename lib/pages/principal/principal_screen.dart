import 'package:flutter/material.dart';
import 'package:local/pages/carrito/carrito.dart';
import 'package:local/pages/detalle_empresa/detalle.dart';
import 'package:local/provider/empresa_provider.dart';
import 'package:local/provider/product_provider.dart';
import 'package:provider/provider.dart';

class PrincipalScreen extends StatefulWidget {
  @override
  State<PrincipalScreen> createState() => _HomePageState();
}

class _HomePageState extends State<PrincipalScreen> {
  @override
  void initState() {
    super.initState();
    // Usar addPostFrameCallback para asegurar que el contexto está completamente inicializado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyProvider>().fetchCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empresas'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Empresas",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<CompanyProvider>(
              builder: (context, companyProvider, child) {
                if (companyProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (companyProvider.errorMessage.isNotEmpty) {
                  return Center(child: Text(companyProvider.errorMessage));
                } else if (companyProvider.companies.isEmpty) {
                  return Center(child: Text('No companies found'));
                } else {
                  return ListView.builder(
                    itemCount: companyProvider.companies.length,
                    itemBuilder: (context, index) {
                      final company = companyProvider.companies[index];
                      return ListTile(
                        title: Text(company.name),
                        subtitle: Text(company.address),
                        trailing: Text(company.phone),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListScreen(companyId: company.id),
                            ),
                          );
                          context.read<ProductProvider>().fetchProductsByCompany(company.id);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
