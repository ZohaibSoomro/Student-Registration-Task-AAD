import 'package:student_registration_aad/database/customer_db_connection.dart';
import 'package:student_registration_aad/model/product.dart';

class ProductDbHelper {
  static const String productsTableName = 'products';
  static const productLines = [
    'Classic Cars',
    'Motorcycles',
    'Plains',
    'Ships',
    'Trains',
    'Trucks and Buses',
    'Vintage Cars',
  ];

  Future<List<Product>> getProductsList() async {
    List<Product> productsList = [];
    final connection = await CustomerDbConnection.connection;
    final records = await connection.query('SELECT * FROM $productsTableName');
    for (var record in records) {
      Product product = Product(
        productCode: record[0],
        productName: record[1],
        productLine: record[2],
        productScale: record[3],
        productVendor: record[4],
        productDescription: record[5].toString(),
        quantityInStock: record[6],
        buyPrice: record[7],
        MSRP: record[8],
      );
      productsList.add(product);
    }
    return productsList;
  }

  Future<List<Product>> getProductsListWithCategory(
      String? productCategory) async {
    List<Product> productsList = await getProductsList();
    if (productCategory == null) return productsList;
    productsList = productsList
        .where((product) => product.productLine == productCategory)
        .toList();
    return productsList;
  }
}
