import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseTodoService().connectDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Safal(),
    );
  }
}

class Safal extends StatefulWidget {
  const Safal({super.key});

  @override
  State<Safal> createState() => _SafalState();
}

class _SafalState extends State<Safal> {
  TextEditingController titleController = TextEditingController();

  TextEditingController subTitle = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDataFromDatabase();
  }

  Future<void> _fetchDataFromDatabase() async {
    final data = await DatabaseTodoService().readDatabase();
    setState(() {
      safal = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await DatabaseTodoService().delete(safal[index].id!);
                  safal.removeAt(index);
                  setState(() {});
                },
              ),
              title: Text(safal[index].title),
              subtitle: Text(safal[index].subtitle),
              leading: Checkbox(
                value: false,
                onChanged: ((value) {}),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: safal.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: "Title",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: subTitle,
                    decoration: InputDecoration(
                        hintText: "subtitle",
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final id = DatabaseTodoService().insert(
                          Saphal(
                            title: titleController.text,
                            date: DateTime.now().toString(),
                            subtitle: subTitle.text,
                          ),
                        );

                        List<Saphal> items = await DatabaseTodoService().readDatabase();
                        setState(() {
                          safal = items;
                        });
                        titleController.clear();
                        subTitle.clear();
                      },
                      child: const Text("Add contain")),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Saphal {
  int? id;
  String title;
  String date;
  String subtitle;

  Saphal({required this.title, required this.date, required this.subtitle, this.id});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'date': DateTime.now().toString(),
    };
  }
}

List<Saphal> safal = [];

class DatabaseTodoService {
  Future<Database> connectDb() async {
    var database = await openDatabase(join(await getDatabasesPath(), 'saphal.db'), version: 1, onCreate: (
      db,
      version,
    ) {
      db.execute('CREATE TABLE tabletodo(id INTEGER PRIMARY KEY,title TEXT,date TEXT,subtitle TEXT)');
    }, onConfigure: onConfigure);
    // if (database != null) {
    //   print('Database connected successfully ');
    //   return database;
    // } else {
    //   print('Unable to connect to database ');
    //   return database;
    // }
    return database;
  }

  onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  insert(Saphal s) async {
    final db = await connectDb();
    db.insert(
      'tableTodo',
      s.toMap(),
    );
  }

  Future<List<Saphal>> readDatabase() async {
    final db = await connectDb();
    final dbRead = await db.query('tabletodo');
    return List.generate(dbRead.length, (index) {
      return Saphal(
        id: dbRead[index]['id'] as int,
        title: dbRead[index]['title'] as String,
        subtitle: dbRead[index]['subtitle'] as String,
        date: dbRead[index]['date'] as String,
      );
    });
  }

  delete(int id) async {
    final db = await DatabaseTodoService().connectDb();
    await db.delete('tabletodo', where: 'id=?', whereArgs: [id]);
  }
}
