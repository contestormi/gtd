import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get list => text()();

  TextColumn get name => text()();

  TextColumn get project => text()();

  BoolColumn get done => boolean()();
}

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  BoolColumn get done => boolean()();
}

@DriftDatabase(tables: [Tasks, Projects])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  Future<void> deleteEverything() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  Stream<List<Task>> taskEntryByList(String list) {
    return ((select(tasks)..where((t) => t.list.equals(list)))
          ..orderBy(
            [(v) => OrderingTerm(expression: v.done, mode: OrderingMode.asc)],
          ))
        .watch();
  }

  void removeTaskEntryByList(int id) {
    (delete(tasks)..where((t) => t.id.equals(id))).go();
  }

  void removeProjectEntryByList(int id) {
    (delete(projects)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<Task>> projectTasksEntryByList(String name) {
    return ((select(tasks)..where((t) => t.project.equals(name)))
          ..orderBy(
            [(v) => OrderingTerm(expression: v.done, mode: OrderingMode.asc)],
          ))
        .watch();
  }

  Stream<List<Project>> allProjects() {
    return ((select(projects)..where((t) => t.name.equals('None').not()))
          ..orderBy(
            [(v) => OrderingTerm(expression: v.done, mode: OrderingMode.asc)],
          ))
        .watch();
  }

  Future<void> insertMultipleEntries() async {
    await batch((batch) {
      batch.insertAll(tasks, [
        TasksCompanion.insert(
            list: 'Inbox',
            name: 'Убраться на даче',
            done: false,
            project: 'None'),
        TasksCompanion.insert(
            list: 'Inbox',
            name: 'Погулять с собакой',
            done: false,
            project: 'None'),
        TasksCompanion.insert(
            list: 'Next',
            name: 'Помыть посуду',
            done: false,
            project: 'Убраться в квартире'),
        TasksCompanion.insert(
            list: 'Project',
            name: 'Полежать на диване',
            done: false,
            project: 'None'),
        TasksCompanion.insert(
            list: 'Wait',
            name: 'Муравьева - выслать титулы',
            done: false,
            project: 'None'),
        TasksCompanion.insert(
            list: 'Archive',
            name: 'Устроиться на работу',
            done: false,
            project: 'None'),
      ]);
    });
    await batch((batch) {
      batch.insertAll(projects, [
        ProjectsCompanion.insert(
          name: 'Написать диплом',
          done: false,
        ),
        ProjectsCompanion.insert(
          name: 'Убраться в квартире',
          done: false,
        ),
      ]);
    });
  }

  Future<void> updateTask(Task task) async {
    try {
      await (update(tasks)..where((e) => e.id.equals(task.id))).write(task);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addTask({
    required String name,
    required String list,
    String project = 'None',
  }) async {
    try {
      into(tasks).insert(
        TasksCompanion.insert(
          name: name,
          project: project,
          list: list,
          done: false,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProject(String name) async {
    try {
      into(projects).insert(
        ProjectsCompanion.insert(
          name: name,
          done: false,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> moveTaskToProject(Task task) async {
    return transaction(() async {
      await (delete(tasks)..where((t) => t.id.equals(task.id))).go();
      await into(projects).insert(
        ProjectsCompanion.insert(
          name: task.name,
          done: false,
        ),
      );
    });
  }

  Future<void> updateProject(Project project) async {
    try {
      await (update(projects)..where((e) => e.id.equals(project.id)))
          .write(project);
    } catch (e) {
      print(e);
    }
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cacheBase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cacheBase;

    return NativeDatabase.createInBackground(file);
  });
}
