import 'package:mysql1/mysql1.dart';

class CustomerDbConnection {
  static MySqlConnection? _connection;
  static const String dbName = 'classicmodels';
  CustomerDbConnection._();
  static Future<MySqlConnection> get connection async {
    if (_connection == null) {
      _connection = await MySqlConnection.connect(
        ConnectionSettings(user: "root", host: "10.0.2.2", db: dbName),
      );
      await _connection!.query("USE $dbName");
    }
    return _connection!;
  }
}
