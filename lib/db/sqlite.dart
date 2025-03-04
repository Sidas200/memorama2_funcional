import 'dart:io' as io;
import 'package:memorama2/config/config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as iguana;
import 'package:path/path.dart';

class Sqlite {
  static Future<iguana.Database> db() async {
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String ruta = join(appDocumentsDir.path, "memorama.db");

    return iguana.openDatabase(
      ruta,
      version: 1,
      singleInstance: true,
      onCreate: (db, version) async {
        await createDb(db);
      },
    );
  }

  static Future<void> createDb(iguana.Database db) async {
    await db.execute("""
      CREATE TABLE memorama (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nivel TEXT NOT NULL,
        victorias INTEGER NOT NULL,
        derrotas INTEGER NOT NULL,
        fecha TEXT NOT NULL
      )
    """);
  }

  static Future<int> guardar(int victorias, int derrotas, String niv) async {
    final iguana.Database db = await Sqlite.db();
    DateTime now = DateTime.now();
    String fecha = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    int id = await db.insert(
      "memorama",
      {"victorias": victoriasGlobal, "derrotas": derrotasGlobal, "fecha": fecha, "nivel": niv},
      conflictAlgorithm: iguana.ConflictAlgorithm.replace,
    );
    victoriasGlobal=0;
    derrotasGlobal=0;

    print("Registro guardado con ID: $id");
    return id;
  }

  static Future<List<Map<String, dynamic>>> consultar() async {
    final iguana.Database db = await Sqlite.db();

    List<Map<String, dynamic>> data = await db.query(
        "memorama",
        orderBy: "datetime(fecha) DESC"
    );

    return data;
  }
}
