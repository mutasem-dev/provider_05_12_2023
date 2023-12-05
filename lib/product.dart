class Product {
  String name;
  double price;
  int quantity;

  Product({required this.name,required this.price,required this.quantity});

  factory Product.fromJson(dynamic jsonObject) {
    return Product(
        name: jsonObject['productName'],
        quantity: jsonObject['quantity'],
        price: jsonObject['price']
    );
  }
  @override
  String toString() {
    return '$name, price: $price, quantity: $quantity';
  }
}