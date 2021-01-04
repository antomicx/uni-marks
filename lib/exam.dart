import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Exam {
  final int id;
  final String name;
  final double mark;
  final int credits;

  Exam({this.id, this.name, this.mark, this.credits});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'mark': mark, 'credits': credits};
  }
}

class ExamWidget extends StatelessWidget {
  final int _id;
  final String _name;
  final double _mark;
  final int _credits;
  Function _callback;

  ExamWidget(this._id, this._name, this._mark, this._credits, this._callback);

  @override
  Widget build(BuildContext context) {
    TextStyle theLocalStyle = Theme.of(context).textTheme.headline5;
    return Card(
      elevation: 10.0,
      shadowColor: Color.fromARGB(100, 100, 100, 100),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Title:",
                    style: theLocalStyle,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Mark:", style: theLocalStyle),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Credits:", style: theLocalStyle),
                ],
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "$_name",
                    style: theLocalStyle,
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "$_mark",
                    style: theLocalStyle,
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "$_credits",
                    style: theLocalStyle,
                  )
                ],
              ),
            ],
          ),
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _callback(_id);
                    },
                    child: Icon(Icons.delete))
              ]),
        ],
      ),
    );
  }
}

class ExamForm extends StatefulWidget {
  @override
  _ExamFormState createState() {
    var myExamFormState = _ExamFormState();
    return myExamFormState;
  }
}

class _ExamFormState extends State<ExamForm> {
  final _formKey = GlobalKey<FormState>();
  final theTitleController = TextEditingController();
  final theMarkController = TextEditingController();
  final theCreditsController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    theTitleController.dispose();
    theMarkController.dispose();
    theCreditsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var myNewExam;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: theTitleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: theMarkController,
            decoration: const InputDecoration(
              hintText: 'Mark',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: theCreditsController,
            decoration: const InputDecoration(
              hintText: 'Credits',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // Process data.
                  myNewExam = new Exam(
                      name: theTitleController.text,
                      credits: int.parse(theCreditsController.text),
                      mark: double.parse(theMarkController.text));

                  Navigator.pop(context, myNewExam);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
