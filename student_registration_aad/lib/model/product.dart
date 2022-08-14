class Product {
  String productCode;
  String productName;
  String productLine;
  String productScale;
  String productVendor;
  String productDescription;
  String? productImageUrl;
  double buyPrice;
  int quantityInStock;
  double MSRP;

  Product({
    required this.productCode,
    required this.productName,
    required this.MSRP,
    required this.buyPrice,
    required this.productDescription,
    required this.productLine,
    required this.productScale,
    required this.productVendor,
    required this.quantityInStock,
    this.productImageUrl,
  });

  @override
  String toString() {
    final product = """{
    product code: $productCode,
    name: $productName,
    description: $productDescription,
  }""";
    return product;
  }
}
