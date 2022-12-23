import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import "post_to_db.dart";

Future<void> main() async {
  // ignore: prefer_const_constructors
  runApp(MaterialApp(
    color: Colors.amber,
    home: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Demo"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: const HomePage(),
    ),
  ));
}

class HomePage extends StatefulHookWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fieldText = TextEditingController();
  void clearText() {
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textInput = useState("");
    final posted = useState("");
    final pressed = useState(false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          textInput.value,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color.fromARGB(255, 16, 5, 26),
              fontWeight: FontWeight.bold,
              fontSize: 40),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: fieldText,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the string',
              contentPadding: EdgeInsets.zero,
              isCollapsed: false,
            ),
            onChanged: (text) {
              textInput.value = text;
            },
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            if (textInput.value == "") {
              pressed.value = false;
              return;
            }

            bool result = await db_post(posted.value);
            posted.value = textInput.value;
            pressed.value = result;
            textInput.value = "";
            clearText();
          },
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
          child: const Text('Send'),
        ),
        pressed.value == true
            ? Text("${posted.value} was added to the Database")
            : const Text(""),
        OutlinedButton(
          onPressed: () async {
            db_clear();
            pressed.value = false;
            clearText();
            textInput.value = "";
          },
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
          child: const Text('Clear all entires'),
        ),
      ],
    );
  }
}
