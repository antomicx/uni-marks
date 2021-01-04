# uniMarks

Sample project to store university exams' marks and compute the current average.
It makes use of a sqlite backend [Sqflite](https://flutter.dev/docs/cookbook/persistence/sqlite) to store and retrieve the list of exams.

It defines a separate ExamWidget taking care of the rendering phase. The main body is implemented through a ListView to provide scrolling capabilities.

## TODOs

* Implement the correct rendering in case of long exam names
* Implement a search function
* When deleting an exam, add a SnackBar to confirm the exam has been deleted.
