import 'product.dart';

class Invoice {
  int invoiceNO;
  String customerName;
  List<Product> products;

  Invoice({required this.invoiceNO, required this.customerName
    , required this.products});

  factory Invoice.fromJson(dynamic jsonObject) {
    return Invoice(
      invoiceNO: jsonObject['invoiceNo'],
      customerName: jsonObject['customerName'],
      products: (jsonObject['products'] as List).map((e) => Product.fromJson(e)).toList(),
    );
  }
  @override
  String toString() {
    String str = 'Invoice# $invoiceNO\n\nProducts:\n';
    int i = 1;
    int totalQuantity = 0;
    double totalPrice = 0;
    for (var element in products) {
      totalQuantity += element.quantity;
      totalPrice += element.quantity*element.price;
      str += '$i- $element\n';
      i++;
    }
    str += '\n\nTotal Quantity: $totalQuantity\n'
        'Total Price: $totalPrice\n';

    return str;
  }
}