import 'package:flutter/material.dart';
import 'database/dict.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});
   // 把MyHomePage設為一個StatefulWidget
  @override
  State<MenuPage> createState() => _MenuPage();
}
class _MenuPage extends State<MenuPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final List<Widget> _pages = [
    Home(),
    TestPage(),
    MyFile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'Test',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.source),
              label: 'File',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
    );
  }
}

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
        'Home page'
      ),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});
  @override
  State<TestPage> createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  List<Voc> problem=[];
  bool flag=false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    problem = await VocDB.getVoc();
    setState(() {
      flag=false;
    });
  }
  void answer(){
    setState(() {
      flag=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (problem.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if(flag) {
      return Scaffold(
        appBar: AppBar(
          title: Text('test'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].voca,
                    style:const TextStyle(fontSize: 30)),
              ],
            ), Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn1,
                    style:const TextStyle(fontSize: 20)),
              ],
            ), Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn2,
                    style:const TextStyle(fontSize: 20)),
              ],
            ), Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn3,
                    style:const TextStyle(fontSize: 20)),
              ],
            ), Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn4,
                    style:const TextStyle(fontSize: 20)),
              ],
            ), Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn5,
                    style:const TextStyle(fontSize: 20)),
              ],
            ), Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    answer();
                  },
                  color: Colors.red,
                  child: const Text(
                    'ANSWER',
                    style: TextStyle(color: Colors.white),
                  ),

                ),MaterialButton(
                  onPressed: () {
                    loadData();
                  },
                  color: Colors.green,
                  child: const Text(
                    'NEXT',
                    style: TextStyle(color: Colors.white),
                  ),

                ),],
            )
          ],
        ),

      );
    }else {
      return Scaffold(
        appBar: AppBar(
          title: Text('test'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].voca,
                    style:const TextStyle(fontSize: 30)),
              ],
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn1.substring(0, 1),
                    style:const TextStyle(fontSize: 20)),
              ],
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn2.substring(0, 1),
                    style:const TextStyle(fontSize: 20)),
              ],
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn3.substring(0, 1),
                    style:const TextStyle(fontSize: 20)),
              ],
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn4.substring(0, 1),
                    style:const TextStyle(fontSize: 20)),
              ],
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(problem[0].syn5.substring(0, 1),
                    style:const TextStyle(fontSize: 20)),
              ],
            ),Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              MaterialButton(
              onPressed: () {
                answer();
              },
                color: Colors.red,
              child: const Text(
                'ANSWER',
                style: TextStyle(color: Colors.white),
              ),

            ),MaterialButton(
              onPressed: () {
                loadData();
              },
                  color: Colors.green,
              child: const Text(
                'NEXT',
                style: TextStyle(color: Colors.white),
              ),

            ),],
            )
          ],
        ),

      );
    }
  }
}


class MyFile extends StatelessWidget{
  Future<void> loadJson(PlatformFile Myfile) async {
    final String jsonString = await File(Myfile.path.toString()).readAsString();
    List<Map<String,dynamic>> data = List.from(json.decode(jsonString) as List);
    VocDB.addVoc(data);
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.any);

    // if no file is picked
    if (result == null) return;
    final file = result.files.first;
    if (file.path.toString().contains('.json')) {
      loadJson(file);
    }else{
      print('Unsupported file type! Need to be json file!');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            _pickFile();
          },
          child: Text(
            'Open file',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
        ),
      ),
    );
  }
}