import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoice_app_2/invoice_model.dart';
import 'package:provider/provider.dart';
import 'details_page.dart';
import 'all_invoices_page.dart';
import 'invoice.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

TextEditingController customerNameController = TextEditingController();
TextEditingController productNameController = TextEditingController();
TextEditingController quantityController = TextEditingController();
TextEditingController priceController = TextEditingController();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InvoiceModel(),
      builder: (context, child) => MaterialApp(
        routes: {
          '/' : (context) => const MainPage(),
          '/all_invoices_page': (context) => const AllInvoicesPage(),
          '/details_page' : (context) => const DetailsPage(),
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
  const MainPage({super.key});
  static late Future<List<Invoice>> invoices;
}
class _MainPageState extends State<MainPage> {

  List<Product> products = [];

  Future<List<Invoice>> fetchInvoices() async{
    http.Response response = await http.get(Uri.parse('https://www.jsonkeeper.com/b/462B'));
    List<Invoice> invoices = [];
    if(response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var jsonArr = jsonObject['invoices'] as List;
      invoices = jsonArr.map((e) => Invoice.fromJson(e)).toList();
    }
    return invoices;
  }

  @override
  void initState() {
    super.initState();
    MainPage.invoices = fetchInvoices();
    MainPage.invoices.then((value) {
      List<Invoice> inv = value;
      //Provider.of<InvoiceModel>(context, listen: false).invoices = inv;
      context.read<InvoiceModel>().invoices = inv;
      if(inv.isNotEmpty) {
        int max = inv[0].invoiceNO;
        for (var element in value) {
          if (element.invoiceNO > max) {
            max = element.invoiceNO;
          }
        }
        context.read<InvoiceModel>().invoiceNo = max + 1;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<InvoiceModel>(
          builder: (context, value, child)
          => Text('Invoice# ${value.invoiceNo}'),
        )
      ),
      body: Column(
        children: [
          TextField(
            controller: customerNameController,
            decoration: const InputDecoration(
              labelText: 'Customer Name',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Products:', style: TextStyle(fontSize: 24),),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Product info:',style: TextStyle(fontSize: 24),),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: productNameController,
                              decoration: const InputDecoration(
                                labelText: 'product Name',
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: quantityController,
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: priceController,
                              decoration: const InputDecoration(
                                labelText: 'Price',
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Product prd = Product(
                                  name: productNameController.text,
                                  price: double.parse(priceController.text),
                                  quantity: int.parse(quantityController.text)
                              );
                              products.add(prd);
                              productNameController.clear();
                              priceController.clear();
                              quantityController.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('add'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('cancel'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('add product'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    tileColor: Colors.blue,
                    leading: Text(products[index].name, style: const TextStyle(fontSize: 30),),
                    title: Text('price: ${products[index].price}'),
                    subtitle: Text('quantity: ${products[index].quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          products.removeAt(index);
                        });

                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Consumer<InvoiceModel>(
                builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: () {
                        Invoice inv = Invoice(
                            invoiceNO: value.invoiceNo,
                            customerName: customerNameController.text,
                            products: products
                        );
                        products = [];
                        value.invoiceNo++;
                        customerNameController.clear();
                        value.addInvoice(inv);
                        setState(() {

                        });
                      },
                      child: const Text('add invoice'),
                    );
                    },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context,'/all_invoices_page');
                },
                child: const Text('show all invoices'),
              ),
            ],
          ),
        ],
      ),
    );
  }

}


