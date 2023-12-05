import 'package:flutter/material.dart';

import 'invoice.dart';

class InvoiceModel extends ChangeNotifier {
  List<Invoice> _invoices = [];
  int invoiceNo = 1;
  int selectedIndex = 0;
  List<Invoice> get invoices => _invoices;
  int length() {
    return _invoices.length;
  }
  set invoices(List<Invoice> value) {
     _invoices = value;
  }
  void addInvoice(Invoice inv) {
    _invoices.add(inv);
    notifyListeners();
  }
  void removeInvoice(int index) {
    _invoices.removeAt(index);
    notifyListeners();
  }
  Invoice getInvoice(int index) {
    return _invoices[index];
  }
}