import 'package:mysql1/mysql1.dart';

class DBConfig {
  static MySqlConnection? connection;

  static Future<MySqlConnection> connect() async {
    if (connection != null) {
      return connection!;
    }

  var settings = ConnectionSettings(
    host: '127.0.0.1',
    port: 3306,
    user: 'root',
    db: 'u754318492_legacy_root',
    password: 'Sy3v>j9\$'
  );


    connection = await MySqlConnection.connect(settings);
    return connection!;
  }
}
