import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/todo_app/cubit/appStates.dart';
import 'package:sqflite/sqflite.dart';

import '../modules/archived_task_screen.dart';
import '../modules/done_task_screen.dart';
import '../modules/new_task_screen.dart';

class appCubit extends Cubit<appStates> {
  appCubit():super (appInitState());

  static appCubit get(context) => BlocProvider.of(context);

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool sheetIsOpen = false;
  IconData fapIcon = Icons.edit;
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen()
  ];
  int currentIndex = 0;


  Future<void> createDb() async {
    openDatabase(
      'todo.db',
      onCreate: (db, version) {
        db
            .execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, titel TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print("database created");
        }).catchError((error) {
          print(error.toString());
        });
      },
      onOpen: (db) {
        print("database opend");
        getFromDb(db);
      },
      version: 1,
    ).then((value) {
      database = value;
      emit(createDbState());
    });
  }

  void deleteDb(String s) {
    deleteDatabase(s);
    print("Database ${s} deleted");
  }

  Future<void> insertIntoDb(String t, String time, String d) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO Tasks (titel,time,date,status) VALUES ("${t}","${time}","${d}","NewTask")')
          .then((value) {
        print(value.toString());
        emit(insertDbState());
      }).catchError((error) {
        print(error.toString());
      });
      return Future(() => null);
    }).then((value) {
      getFromDb(database);
    });
  }

  getFromDb(Database database)  {
    database.rawQuery('SELECT * FROM Tasks where status = "NewTask"').then((value) {
      newTasks = value;
      emit(getDbState());
      print(value);

    });
    database.rawQuery('SELECT * FROM Tasks where status = "done"').then((value) {
      doneTasks = value;
      emit(getDbState());
      print(value);

    });
    database.rawQuery('SELECT * FROM Tasks where status = "archive"').then((value) {
      archiveTasks = value;
      emit(getDbState());
      print(value);
    });
  }

  void changeNavBarState (int index){
    currentIndex = index;
    emit(navBarChangeState());
  }
  void changeBottomSheetState (bool isShow,IconData icon){
    sheetIsOpen = isShow;
    fapIcon = icon;
    emit(bottomSheetChangeState());
  }
  void updateDb ({required String state , required int id}){
    database.rawUpdate('UPDATE Tasks SET status = ?  where id = ? ', ['$state', id]).then((value) {
      emit(updateDbState());
      getFromDb(database);
      emit(getDbState());
    });
  }

  void deleteFormDb (int id){
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      emit(deleteDbState());
      getFromDb(database);
      emit(getDbState());
    });
  }


}