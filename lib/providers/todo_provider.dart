import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ToDoProvider with ChangeNotifier {
  List<Map> allTasks = [];
  var database;

  bool? completed;
  void createDatabase() {
    database = openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT ,status TEXT)')
            .then((value) {
          notifyListeners();
        }).catchError((error) {});
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        notifyListeners();
      },
    ).then((value) {
      database = value;
      notifyListeners();
    });
  }

  insertToDatabase({
    required String title,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert('INSERT INTO Tasks(title,status) VALUES("$title","new")')
          .then((value) {
        print('insert successfully');
        notifyListeners();

        getDataFromDataBase(database);
      }).catchError((error) {
        print('error when insert data ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDataBase(Database database) {
    allTasks = [];
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          allTasks.add(element);
          completed = false;
                  notifyListeners();

        } else if (element['status'] == 'done') {
          allTasks.add(element);
          completed = true;
                  notifyListeners();

        }
        notifyListeners();
      });
    });
  }

  void updateData({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDataBase(database);
      notifyListeners();
    });
  }

  void deleteData({required int id}) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      notifyListeners();
    });
  }
}
