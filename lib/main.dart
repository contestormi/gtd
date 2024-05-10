import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  await database.deleteEverything();
  await database.insertMultipleEntries();

  runApp(MyApp(
    database: database,
  ));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyNavigationBar(
        database: database,
      ),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key, required this.database});

  final AppDatabase database;

  @override
  MyNavigationBarState createState() => MyNavigationBarState();
}

class MyNavigationBarState extends State<MyNavigationBar> {
  late final AppDatabase database;

  @override
  void initState() {
    database = widget.database;
    super.initState();
  }

  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions = <Widget>[
    Inbox(
      database: database,
    ),
    ProjectScreen(
      database: database,
    ),
    Next(
      database: database,
    ),
    Wait(
      database: database,
    ),
    Archive(
      database: database,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Flutter BottomNavigationBar Example'),
          backgroundColor: Colors.green),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.inbox),
                label: 'Корзина',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_tree),
                label: 'Проекты',
                backgroundColor: Colors.yellow),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt),
              label: 'Текущие действия',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Ожидание',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive),
              label: 'КНП',
              backgroundColor: Colors.blue,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}

class PlusMinusEntry extends PopupMenuEntry<int> {
  @override
  double height = 100;

  final AppDatabase database;
  final Task task;

  PlusMinusEntry(this.database, this.task);

  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().

  @override
  bool represents(int? value) => value == 1 || value == -1;

  @override
  PlusMinusEntryState createState() => PlusMinusEntryState();
}

class PlusMinusEntryState extends State<PlusMinusEntry> {
  bool needToDo = false;
  bool rightNow = false;
  bool forMe = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    content: Container(
                      height: 100,
                      width: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Введите названия задачи'),
                          TextFormField(
                            onFieldSubmitted: (text) {
                              widget.database.updateTask(
                                Task(
                                  id: widget.task.id,
                                  list: widget.task.list,
                                  name: text,
                                  done: widget.task.done,
                                  project: widget.task.project,
                                ),
                              );
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text('Переименовать'),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    content: Container(
                      height: 150,
                      width: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Куда?'),
                          GestureDetector(
                            onTap: () {
                              widget.database.updateTask(
                                Task(
                                  id: widget.task.id,
                                  list: 'Inbox',
                                  name: widget.task.name,
                                  done: widget.task.done,
                                  project: widget.task.project,
                                ),
                              );
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text('Корзина'),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.database.moveTaskToProject(
                                Task(
                                  id: widget.task.id,
                                  list: widget.task.list,
                                  name: widget.task.name,
                                  done: widget.task.done,
                                  project: widget.task.project,
                                ),
                              );
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text('Проекты'),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.database.updateTask(
                                Task(
                                  id: widget.task.id,
                                  list: 'Wait',
                                  name: widget.task.name,
                                  done: widget.task.done,
                                  project: widget.task.project,
                                ),
                              );
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text('Делегирование'),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.database.updateTask(
                                Task(
                                  id: widget.task.id,
                                  list: 'Next',
                                  name: widget.task.name,
                                  done: widget.task.done,
                                  project: widget.task.project,
                                ),
                              );
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text('Текущие действия'),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.database.updateTask(
                                Task(
                                  id: widget.task.id,
                                  list: 'Archive',
                                  name: widget.task.name,
                                  done: widget.task.done,
                                  project: widget.task.project,
                                ),
                              );
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text('КНП'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              'Переместить',
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      content: Container(
                        height: 280,
                        width: 200,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Нужно ли что-то делать с задачей?',
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Да'),
                                Switch(
                                  value: needToDo,
                                  onChanged: (val) {
                                    setState(() {
                                      needToDo = val;
                                    });
                                  },
                                ),
                                Text('Нет'),
                              ],
                            ),
                            Text('Сейчас?'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Да'),
                                Switch(
                                  value: rightNow,
                                  onChanged: (val) {
                                    setState(() {
                                      rightNow = val;
                                    });
                                  },
                                ),
                                Text('Нет'),
                              ],
                            ),
                            Text('Мне?'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Да'),
                                Switch(
                                  value: forMe,
                                  onChanged: (val) {
                                    setState(() {
                                      forMe = val;
                                    });
                                  },
                                ),
                                Text('Нет'),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (needToDo) {
                                  widget.database
                                      .removeTaskEntryByList(widget.task.id);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                } else if (rightNow) {
                                  widget.database.updateTask(Task(
                                    id: widget.task.id,
                                    list: 'Archive',
                                    name: widget.task.name,
                                    done: widget.task.done,
                                    project: widget.task.project,
                                  ));
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                } else if (forMe) {
                                  widget.database.updateTask(Task(
                                    id: widget.task.id,
                                    list: 'Wait',
                                    name: widget.task.name,
                                    done: widget.task.done,
                                    project: widget.task.project,
                                  ));
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }
                                needToDo = false;
                                rightNow = false;
                                forMe = false;
                              },
                              child: Text(
                                'Поехали',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            },
            child: Text(
              'Пройти по алгоритму',
            ),
          ),
        ],
      ),
    );
  }
}

class Inbox extends StatefulWidget {
  const Inbox({super.key, required this.database});

  final AppDatabase database;

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  var _count = 0;
  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showCustomMenu(Task task) async {
    if (_tapPosition == null) {
      return;
    }
    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay == null) {
      return;
    }

    final delta = await showMenu(
      context: context,
      items: <PopupMenuEntry<int>>[PlusMinusEntry(widget.database, task)],
      position: RelativeRect.fromRect(
          _tapPosition! & const Size(40, 40), // smaller rect, the touch area
          Offset.zero &
              overlay.semanticBounds.size // Bigger rect, the entire screen
          ),
    );

    // delta would be null if user taps on outside the popup menu
    // (causing it to close without making selection)
    if (delta == null) {
      return;
    }

    setState(() {
      _count = _count + delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Container(
                  height: 100,
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Введите названия задачи'),
                      TextFormField(
                        onFieldSubmitted: (text) {
                          widget.database.addTask(name: text, list: 'Inbox');
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Task>>(
        stream: widget.database.taskEntryByList('Inbox'),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data?.length ?? 0,
              itemBuilder: (ctx, index) {
                return Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (ctx) {
                          widget.database
                              .removeTaskEntryByList(snap.data![index].id);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onLongPress: () => _showCustomMenu(snap.data![index]),
                    onTapDown: _storePosition,
                    child: Row(
                      children: [
                        Checkbox(
                          value: snap.data?[index].done,
                          onChanged: (val) {
                            widget.database.updateTask(
                              Task(
                                id: snap.data![index].id,
                                list: snap.data![index].list,
                                name: snap.data![index].name,
                                done: val!,
                                project: snap.data![index].project,
                              ),
                            );
                          },
                        ),
                        Text(
                          snap.data?[index].name ?? '',
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Next extends StatefulWidget {
  const Next({super.key, required this.database});

  final AppDatabase database;

  @override
  State<Next> createState() => _NextState();
}

class _NextState extends State<Next> {
  var _count = 0;

  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showCustomMenu(Task task) async {
    if (_tapPosition == null) {
      return;
    }
    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay == null) {
      return;
    }

    final delta = await showMenu(
      context: context,
      items: <PopupMenuEntry<int>>[PlusMinusEntry(widget.database, task)],
      position: RelativeRect.fromRect(
          _tapPosition! & const Size(40, 40), // smaller rect, the touch area
          Offset.zero &
              overlay.semanticBounds.size // Bigger rect, the entire screen
          ),
    );

    // delta would be null if user taps on outside the popup menu
    // (causing it to close without making selection)
    if (delta == null) {
      return;
    }

    setState(() {
      _count = _count + delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Container(
                  height: 100,
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Введите названия задачи'),
                      TextFormField(
                        onFieldSubmitted: (text) {
                          widget.database.addTask(name: text, list: 'Next');
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Task>>(
        stream: widget.database.taskEntryByList('Next'),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data?.length ?? 0,
              itemBuilder: (ctx, index) {
                final projectName = snap.data?[index].project ?? '';
                return Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (ctx) {
                          widget.database
                              .removeTaskEntryByList(snap.data![index].id);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onLongPress: () => _showCustomMenu(snap.data![index]),
                    onTapDown: _storePosition,
                    child: Row(
                      children: [
                        Checkbox(
                          value: snap.data?[index].done,
                          onChanged: (val) {
                            widget.database.updateTask(
                              Task(
                                id: snap.data![index].id,
                                list: snap.data![index].list,
                                name: snap.data![index].name,
                                done: val!,
                                project: snap.data![index].project,
                              ),
                            );
                          },
                        ),
                        Text(
                          snap.data?[index].name ?? '',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          projectName != 'None' ? projectName : '',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Container(
                  height: 100,
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Введите названия проекта'),
                      TextFormField(
                        onFieldSubmitted: (text) {
                          widget.database.addProject(text);
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Project>>(
        stream: widget.database.allProjects(),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data?.length ?? 0,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProjectScreenInfo(
                          database: widget.database,
                          name: snap.data![index].name,
                        ),
                      ),
                    );
                  },
                  child: Slidable(
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (ctx) {
                            widget.database
                                .removeProjectEntryByList(snap.data![index].id);
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: snap.data?[index].done,
                          onChanged: (val) {
                            widget.database.updateProject(
                              Project(
                                id: snap.data![index].id,
                                name: snap.data![index].name,
                                done: val!,
                              ),
                            );
                          },
                        ),
                        Text(
                          snap.data?[index].name ?? '',
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ProjectScreenInfo extends StatefulWidget {
  const ProjectScreenInfo(
      {super.key, required this.database, required this.name});

  final AppDatabase database;
  final String name;

  @override
  State<ProjectScreenInfo> createState() => _ProjectScreenInfoState();
}

class _ProjectScreenInfoState extends State<ProjectScreenInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Container(
                  height: 100,
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Введите названия задачи'),
                      TextFormField(
                        onFieldSubmitted: (text) {
                          widget.database.addTask(
                            name: text,
                            list: 'Next',
                            project: widget.name,
                          );
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: widget.database.projectTasksEntryByList(widget.name),
              builder: (ctx, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                    itemCount: snap.data?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      return Slidable(
                        key: ValueKey(index),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (ctx) {
                                widget.database.removeTaskEntryByList(
                                    snap.data![index].id);
                              },
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: snap.data?[index].done,
                              onChanged: (val) {
                                widget.database.updateTask(
                                  Task(
                                    id: snap.data![index].id,
                                    name: snap.data![index].name,
                                    done: val!,
                                    project: snap.data![index].project,
                                    list: snap.data![index].list,
                                  ),
                                );
                              },
                            ),
                            Text(
                              snap.data?[index].name ?? '',
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Wait extends StatefulWidget {
  const Wait({super.key, required this.database});

  final AppDatabase database;

  @override
  State<Wait> createState() => _WaitState();
}

class _WaitState extends State<Wait> {
  var _count = 0;

  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showCustomMenu(Task task) async {
    if (_tapPosition == null) {
      return;
    }
    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay == null) {
      return;
    }

    final delta = await showMenu(
      context: context,
      items: <PopupMenuEntry<int>>[PlusMinusEntry(widget.database, task)],
      position: RelativeRect.fromRect(
          _tapPosition! & const Size(40, 40), // smaller rect, the touch area
          Offset.zero &
              overlay.semanticBounds.size // Bigger rect, the entire screen
          ),
    );

    // delta would be null if user taps on outside the popup menu
    // (causing it to close without making selection)
    if (delta == null) {
      return;
    }

    setState(() {
      _count = _count + delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Container(
                  height: 100,
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Введите названия задачи'),
                      TextFormField(
                        onFieldSubmitted: (text) {
                          widget.database.addTask(name: text, list: 'Wait');
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Task>>(
        stream: widget.database.taskEntryByList('Wait'),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data?.length ?? 0,
              itemBuilder: (ctx, index) {
                return Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (ctx) {
                          widget.database
                              .removeTaskEntryByList(snap.data![index].id);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onLongPress: () => _showCustomMenu(snap.data![index]),
                    onTapDown: _storePosition,
                    child: Row(
                      children: [
                        Checkbox(
                          value: snap.data?[index].done,
                          onChanged: (val) {
                            widget.database.updateTask(
                              Task(
                                id: snap.data![index].id,
                                list: snap.data![index].list,
                                name: snap.data![index].name,
                                done: val!,
                                project: snap.data![index].project,
                              ),
                            );
                          },
                        ),
                        Text(
                          snap.data?[index].name ?? '',
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Archive extends StatefulWidget {
  const Archive({super.key, required this.database});

  final AppDatabase database;

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  var _count = 0;

  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showCustomMenu(Task task) async {
    if (_tapPosition == null) {
      return;
    }
    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay == null) {
      return;
    }

    final delta = await showMenu(
      context: context,
      items: <PopupMenuEntry<int>>[PlusMinusEntry(widget.database, task)],
      position: RelativeRect.fromRect(
          _tapPosition! & const Size(40, 40), // smaller rect, the touch area
          Offset.zero &
              overlay.semanticBounds.size // Bigger rect, the entire screen
          ),
    );

    // delta would be null if user taps on outside the popup menu
    // (causing it to close without making selection)
    if (delta == null) {
      return;
    }

    setState(() {
      _count = _count + delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Container(
                  height: 100,
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Введите названия задачи'),
                      TextFormField(
                        onFieldSubmitted: (text) {
                          widget.database.addTask(name: text, list: 'Archive');
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Task>>(
        stream: widget.database.taskEntryByList('Archive'),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data?.length ?? 0,
              itemBuilder: (ctx, index) {
                return Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (ctx) {
                          widget.database
                              .removeTaskEntryByList(snap.data![index].id);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onLongPress: () => _showCustomMenu(snap.data![index]),
                    onTapDown: _storePosition,
                    child: Row(
                      children: [
                        Checkbox(
                          value: snap.data?[index].done,
                          onChanged: (val) {
                            widget.database.updateTask(
                              Task(
                                id: snap.data![index].id,
                                list: snap.data![index].list,
                                name: snap.data![index].name,
                                done: val!,
                                project: snap.data![index].project,
                              ),
                            );
                          },
                        ),
                        Text(
                          snap.data?[index].name ?? '',
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
