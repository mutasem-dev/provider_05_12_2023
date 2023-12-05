import 'package:flutter/material.dart';
import 'package:invoice_app_2/invoice_model.dart';
import 'package:provider/provider.dart';
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<InvoiceModel>(
          builder: (context, value, child) {
              return Text(value.getInvoice(value.selectedIndex).customerName);

          },
        ),
      ),
      body: Consumer<InvoiceModel>(
        builder: (context, value, child) {
            return Text(value.getInvoice(value.selectedIndex).toString(),
              style: const TextStyle(fontSize: 25),);
        },
      ),
    );
  }
}
