import 'package:student_registration_aad/database/customer_db_connection.dart';

import '../model/customer.dart';

class CustomerDbHelper {
  static const String customersTableName = 'customers';

  Future<Customer?> getCustomer(int customerNumber) async {
    final connection = await CustomerDbConnection.connection;
    Customer? customer;
    final record = await connection.query(
        'SELECT * FROM $customersTableName where customerNumber=$customerNumber');
    if (record.isNotEmpty) {
      final row = record.first;
      customer = Customer(
        customerNumber: row[0],
        customerLastName: row[2],
        customerFirstName: row[3],
        phone: row[4],
        addressLine1: row[5],
        city: row[7],
        state: row[8],
        postalCode: row[9],
        salesRepEmployeeNumber: row[10],
        country: row[10],
        creditLimit: row[10],
      );
    }
    return customer;
  }
}
