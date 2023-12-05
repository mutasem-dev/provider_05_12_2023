import 'package:flutter/material.dart';
import 'package:invoice_app_2/invoice.dart';
import 'package:invoice_app_2/invoice_model.dart';
import 'package:provider/provider.dart';
import 'main.dart';
class AllInvoicesPage extends StatelessWidget {
  const AllInvoicesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Customers'),
      ),
      body: Consumer<InvoiceModel>(
        builder: (context, value, child) {         
            return ListView.builder(
              itemCount: value.length(),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onHorizontalDragEnd: (details) => value.removeInvoice(index),
                  onTap: () {
                    value.selectedIndex = index;
                    Navigator.pushNamed(context,'/details_page');
                  },
                  child: Container(
                    color: Colors.lightBlueAccent,
                    child: Text(value.getInvoice(index).customerName,
                      style: const TextStyle(fontSize: 25),),
                  ),
                ),
              ),
            );
        },
      ),
    );
  }
}