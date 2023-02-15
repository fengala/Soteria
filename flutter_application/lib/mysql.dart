import 'package:mysql1/mysql1.dart';

class MySql {
  static String host = "localhost";
  static String user = "root";
  static String password = "Soteria45\$";
  static String db = "soteria";
  static int port = 3306;

  MySql();

  Future<MySqlConnection> getConnection() async {
    // ignore: unnecessary_new
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);

    return await MySqlConnection.connect(settings);
  }
}
