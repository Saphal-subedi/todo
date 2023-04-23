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
  Safal({super.key});

  @override
  State<Safal> createState() => _SafalState();
}

class _SafalState extends State<Safal> {
  TextEditingController titleController = TextEditingController();

  TextEditingController subTitle = TextEditingController();
  @override
  void initState() {
    super.initState();
    DatabaseTodoService().readDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {},
              ),
              title: Text(titleController.text[index]),
              subtitle: Text(subTitle.text[index]),
              leading: Checkbox(
                value: false,
                onChanged: ((value) {}),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
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
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                  TextButton(
                      onPressed: () {
                        DatabaseTodoService().insert(saphal(
                          title: titleController.text,
                          date: DateTime.now().toString(),
                          subtitle: subTitle.text,
                        ));
                        Navigator.pop(context);
                      },
                      child: Text("Add contain")),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class saphal {
  int? id;
  String title;
  String date;
  String subtitle;
  saphal(
      {required this.title,
      required this.date,
      required this.subtitle,
      this.id});
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'date': DateTime.now().toString(),
    };
  }
}

List<saphal> safal = [];

class DatabaseTodoService {
  Future<Database> connectDb() async {
    var database = await openDatabase(
        join(await getDatabasesPath(), 'saphal.db'),
        version: 1, onCreate: (
      db,
      version,
    ) {
      db.execute(
          'CREATE TABLE tabletodo(id INTEGER PRIMARY KEY,title TEXT,date TEXT,subtitle TEXT)');
    }, onConfigure: onConfigure);
    if (database != null) {
      print('Database connected successfully ');
      return database;
    } else {
      print('Unable to connect to database ');
      return database;
    }
  }

  onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  insert(saphal s) async {
    final db = await connectDb();
    db.insert(
      'tableTodo',
      s.toMap(),
    );
  }

  Future<List<saphal>> readDatabase() async {
    final db = await connectDb();
    final dbread = await db.query('tabletodo');
    return List.generate(dbread.length, (index) {
      return saphal(
        id: dbread[index]['id'] as int,
        title: dbread[index]['title'] as String,
        subtitle: dbread[index]['subtitle'] as String,
        date: dbread[index]['date'] as String,
      );
    });
  }
}

// delete(int id) async {
//   final db = DatabaseTodoService().connectDb();
//   await db.delete('tabletodo', where: 'id=?', whereArgs: [id]);
// }
