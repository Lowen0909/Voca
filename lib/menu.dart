import 'package:flutter/material.dart';
import 'database/dict.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'dart:convert';

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
    Test(),
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
class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            'Test page'
        ),
      ),
    );
  }
}
class MyFile extends StatelessWidget{
  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }
  Future<void> loadJson(PlatformFile Myfile) async {
    final String jsonString = await File(Myfile.path.toString()).readAsString();
    List<Map<String,dynamic>> data = List.from(json.decode(jsonString) as List);;
    print(data);
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.custom,
      allowedExtensions: ['json'],);

    // if no file is picked
    if (result == null) return;
    final file = result.files.first;
    loadJson(file);
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