import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Voc {
  // final int id;
  final String voca;
  final String syn1;
  final String syn2;
  final String syn3;
  final String syn4;
  final String syn5;
  Voc({required this.voca,required this.syn1,required this.syn2,
    required this.syn3,required this.syn4,required this.syn5});
  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'voca': voca,
      'syn1': syn1,
      'syn2': syn2,
      'syn3': syn3,
      'syn4': syn4,
      'syn5': syn5,
    };
  }
}

class VocDB {
  //初始化db
  static late Database database;
  // 用來確認使否已經建立db
  static bool isConnect=false;
  static Future<Database> initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'Voc.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE vocDict(id INTEGER PRIMARY KEY AUTOINCREMENT, voca TEXT UNIQUE, "
            "syn1 TEXT,syn2 TEXT,syn3 TEXT,syn4 TEXT,syn5 TEXT)",
      );
    },
    version: 1,
    );
    isConnect=true;
    return database;
  }
  static Future<Database> getDBConnect() async {
    if (isConnect) {
      return database;
    }
    return await initDatabase();
  }
  // CRUD
  // create
  // static Future<void> addVoc(Voc voc) async {
  //   final Database db = await getDBConnect();
  //   await db.insert(
  //     'vocDict',
  //     voc.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.ignore,
  //   );
  // }
  static Future<void> addVoc(List<Map<String,dynamic>>jsonfile) async {
    final Database db = await getDBConnect();
    final Batch batch = db.batch();

    for (Map<String,dynamic> voc in jsonfile) {
      batch.insert('vocDict', voc);
    }

    final List<dynamic> result = await batch.commit();
    final int affectedRows = result.reduce((sum, element) => sum + element);
    print(affectedRows);
  }
  // get 1
  static Future<List<Voc>> getVoc() async {
    final Database db = await getDBConnect();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM vocDict ORDER BY RANDOM() LIMIT 1");
    return List.generate(maps.length, (i) {
      return Voc(
        // id: maps[i]['id'],
        voca: maps[i]['voca'],
        syn1: maps[i]['syn1'],
        syn2: maps[i]['syn2'],
        syn3: maps[i]['syn3'],
        syn4: maps[i]['syn4'],
        syn5: maps[i]['syn5'],
      );
    });
  }

}