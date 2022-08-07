import 'package:mysql1/mysql1.dart';

class DbConnection {
  static MySqlConnection? _connection;
  static const String dbName = 'info';
  DbConnection._();
  static Future<MySqlConnection> get connection async {
    if (_connection == null) {
      _connection = await MySqlConnection.connect(
        ConnectionSettings(user: "root", host: "10.0.2.2"),
      );
      await _connection!.query("CREATE DATABASE IF NOT EXISTS $dbName ");
      print('Database "$dbName" created successfully.');
      await _connection!.query("USE $dbName");
    }
    return _connection!;
  }
}
