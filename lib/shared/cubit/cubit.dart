import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived.dart';
import 'package:todo_app/modules/done.dart';
import 'package:todo_app/modules/tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';
/* 
class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  int bottomNavigtionIndex = 0;
  List<Widget> screens = [
    TasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  Database? database;
  List<String> titles = ['Todo Tasks', 'Done Tasks', 'Archived Tasks'];
  bool isBottomSheetShown = false;
  IconData fabicon = Icons.edit;

  void changeIndex(int index) {
    bottomNavigtionIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void updateDatabase({required String status, required int id}) async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                //id integer
                //title string
                //data string
                //time string
                //status string
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) => print('Table Created'))
            .catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataBase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreteDatabaseState());
    });
  }

  void getDataBase(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      //print(value);
      value.forEach((element) {
        print(element['id']);
        if (element['status'] == 'New') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  inserToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES ("$title","$date","$time","New")')
          .then((value) {
        getDataBase(database);
        print('$value Inserted Successfully');
        emit(AppInsertToDatabaseState());
      }).catchError((error) {
        print('Error When inserting Table ${error.toString()}');
      });
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    icon = fabicon;
    emit(AppChangeBottomSheetState());
  }
}
 */

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit_rounded;

  List<Widget> Screens = [
    TasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> Titles = ["New Tasks", "Done Tasks", "Archived Tasks"];

  Database? database;

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print("Database created");
      database
          .execute(
              "create table Tasks (Id INTEGER PRIMARY KEY, Title TEXT, Date TEXT, Time TEXT, Status TEXT)")
          .then((value) {
        print("table created");
      }).catchError((error) {
        print("${error.toString()}");
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print("Database opened");
    }).then((value) {
      database = value;
      emit(AppCreteDatabaseState());
    });
  }

  int? id;

  insertToDatabase(
      {required String title,
      required String date,
      required String time}) async {
    await database!.transaction((txn) async {
      id = await txn
          .rawInsert(
              'insert into Tasks(Title, Date, Time, Status) values ("$title", "$date", "$time", "new")')
          .then((value) {
        print("$value  raw inserted");
        emit(AppInsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print("error is ${error.toString()}");
      });
    });
  }

  List<Map> Newtasks = [];
  List<Map> Donetasks = [];
  List<Map> Archivedtasks = [];

  void getDataFromDatabase(database) {
    Newtasks = [];
    Donetasks = [];
    Archivedtasks = [];
    emit(AppGetDatabaseloadingState());
    database!.rawQuery("Select * From Tasks").then((value) {
      value.forEach((element) {
        if (element['Status'] == 'new') {
          Newtasks.add(element);
        } else if (element['Status'] == 'done') {
          Donetasks.add(element);
        } else
          Archivedtasks.add(element);
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateData({required String status, required int id}) {
    database!.rawUpdate(
      'UPDATE Tasks SET Status = ? WHERE id = ?',
      ['${status}', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void DeleteData({required int id}) {
    database!.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void ChangeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void ChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
