import 'package:flutter/material.dart';
import 'exam.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

// Open the database and store the reference.
  openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'exams_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE exams(id INTEGER PRIMARY KEY, name TEXT, mark REAL, credits INTEGER)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniMarks',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppBody(),
    );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  List<Exam> _listOfExams;
  Future<Database> _database;

// Define a function that inserts dogs into the database
  Future<void> insertExam(Exam exam) async {
    // Get a reference to the database.
    final Database db = await _database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'exams',
      exam.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteExam(int id) async {
    // Get a reference to the database.
    final db = await _database;

    // Remove the Exam from the Database.
    await db.delete(
      'exams',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Exam's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<List<Exam>> exams() async {
    // Get a reference to the database.
    final Database db = await _database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('exams');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Exam(
          id: maps[i]['id'],
          name: maps[i]['name'],
          mark: maps[i]['mark'],
          credits: maps[i]['credits']);
    });
  }

  Future<Database> _loadData() async {
// Open the database and store the reference.
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'exams_database.db'),
    );

    // Insert a dog into the database.
    return database;
  }

  @override
  Widget build(BuildContext context) {
    _database = _loadData();
    final myExams = exams();

    return Scaffold(
      appBar: AppBar(
        title: Text("List of Exams"),
      ),
      body: Center(
        child: FutureBuilder<List<Exam>>(
          future: myExams, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<Exam>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              _listOfExams = snapshot.data;
              children = [
                for (var exam in _listOfExams)
                  ExamWidget(exam.id, exam.name, exam.mark, exam.credits,
                      (examId) async {
                    await deleteExam(examId);
                    setState(() {});
                  })
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }

            return Center(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: children,
              ),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.calculate),
              elevation: 10.0,
              onPressed: () {
                var myCurrentSum = 0.0;
                var myTotalWeigth = 0.0;
                final myNumberOfExams = _listOfExams.length;

                if (myNumberOfExams == 0) {
                  return;
                }

                for (var exam in _listOfExams) {
                  myTotalWeigth += (12.0 / exam.credits);
                  myCurrentSum += (exam.mark * 12.0 / exam.credits);
                }
                final myAverage = myCurrentSum / myTotalWeigth;

                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('Your average'),
                          content: Text(
                              'You have an average mark of $myAverage computed on $myNumberOfExams exams'),
                        ));
              }),
          FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.add),
              elevation: 10.0,
              onPressed: () {
                _navigateAndDisplaySelection(context);
              }),
        ],
      ),
    );
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Add a new Exam"),
            ),
            body: Center(
              child: ExamForm(),
            ));
      }),
    );

    if (result != null) {
      final Exam myExam = result;
      await insertExam(myExam);

      setState(() {});
    }
  }
}
