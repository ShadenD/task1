// ignore_for_file: unused_import, avoid_print

import 'package:sqflite/sqflite.dart'; // تحتوي على ال join
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:welcom/model/user.dart';

class SqlDB {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initdb();
      // ignore: recursive_getters
      return _db;
    } else {
      // ignore: recursive_getters
      return _db;
    }
  }

  initdb() async {
    print("initdb initdb initdb");
    String databasepath =
        await getDatabasesPath(); // مسار وموقع الداتا بيس افتراضي من عنده
    String path = join(databasepath,
        'shaden2.db'); //  اسم الداتا بيس ونربطه بمسار الداتا بيس حتى يكون حاهز لفينكشن الداتا بيس
    // join used to create path like databasepath/shaden.db
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    // onCreate: بتم استدعاها مرة واحدة فقط وهي عند انشاء الداتا بيس فأي اضافة جدول اخر ما رح يتم انشاؤه والحل هو تغييرversion , onUpgrade
    return mydb;
  }

//onUpgrade: يتم استدعائها عندما يتغير الفيرجين يعني عتدما يتم تغيير على الداتا بيس
  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade================");
  }

// onCreate used to create tabels.
  _onCreate(Database db, int version) async {
    print("CREATE DATABASE");
    await db.execute('''
CREATE TABLE "users"(
"id" INTEGER  PRIMARY KEY AUTOINCREMENT,
"username" TEXT NOT NULL,
"email" TEXT NOT NULL,
"pass" TEXT NOT NULL,
"bod" TEXT NOT NULL,
"photo" TEXT NOT NULL


)
    ''');
    await db.execute('''
CREATE TABLE "orders"(
"order_id" INTEGER  PRIMARY KEY AUTOINCREMENT,
"order_date" TEXT NOT NULL,
"order_amount" INTEGER NOT NULL,
"equal_order_amount" INTEGER NOT NULL,
"curr_id" INTEGER NOT NULL,
"status" BOOLEAN NOT NULL,
"type" TEXT NOT NULL,
"user_id" INTEGER NOT NULL,
FOREIGN KEY (curr_id) REFERENCES currency(currency_id),
FOREIGN KEY (user_id) REFERENCES users(id)

)
    ''');
    await db.execute('''
CREATE TABLE "currency"(
"currency_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
"curreny_name" TEXT NOT NULL,
"currency_symbol" TEXT NOT NULL,
"rate" REAL NOT NULL
)
    ''');
  }

  // ما دام الفنكشن future لازم await
  // الفنكشن مشان select
  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql); // rawQuery خصاة بالسليكت
    // ! بحكيله على ضمانتي انها مش null لانه ان اكنت حاطة علامة الاسنفهام الى بدل على الnull
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deletData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  mydeleteDatabse() async {
    String databasepath =
        await getDatabasesPath(); // مسار وموقع الداتا بيس افتراضي من عنده
    String path = join(databasepath, 'shaden2.db');
    await deleteDatabase(path);
  }

  updateOrderState(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  readJoin(String sql) async {
    Database? mydb = await db;
    List response = await mydb!.rawQuery(sql);
    return response;
  }

  delete(String table, String where) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: where);
    return response;
  }

  insert(String table, Map<String, dynamic> user) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, user);
    return response;
  }

  update(String table, Map<String, String> user, String where) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, user, where: where);
    return response;
  }
}
 
// int: لانهم برجعوا كم سطر نحذف او كم سطر تم اضافته ووووو
