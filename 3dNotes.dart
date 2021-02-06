import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

const String notesBoxName = "Notes";

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String content;
  Note(this.content);
}

const String titlesBoxName = "Titles";

@HiveType(typeId: 1)
class Title {
  @HiveField(0)
  String caption;
  Title(this.caption);
}

Future<void> main() async{

  await Hive.initFlutter();
  Hive.registerAdapter<Note>(NoteAdapter());
  await Hive.openBox<Note>(notesBoxName);
  Hive.registerAdapter<Title>(TitleAdapter());
  await Hive.openBox<Title>(titlesBoxName);
  runApp(MaterialApp(
    title: '3-Way Notes',
    home: TopicsScreen(
    ),
  ));
}

class TopicsScreen extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();
  String title;
  int indicet = 0;
   
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('3-Way Notes'),
          backgroundColor: Colors.black54,
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<Title>(titlesBoxName).listenable(),
          builder: (context, Box<Title> box, _) {
            if (box.values.isEmpty)
              return Center(
                child: Text("No notes"),
              );
            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Title currentTitle = box.getAt(index);
                return Card(
                  clipBehavior: Clip.antiAlias, 
                  child: InkWell(
                   onTap: () { 
                   indicet = index;
                   Navigator.push(
                   context,
                   MaterialPageRoute(
                   builder: (context) => AddNote(topic: indicet),
                    ),
                   );
                   },
                 
                    onLongPress: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        child: AlertDialog(
                          content: Text(
                            "Do you want to delete ${currentTitle.caption}?",
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("No"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            FlatButton(
                              child: Text("Yes"),
                              onPressed: () async {
                                await box.deleteAt(index);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(currentTitle.caption),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
         
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.black54,
              onPressed: () {
                  showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Note'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Note Title"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {         
                Box<Title> titlesBox = Hive.box<Title>(titlesBoxName);
                  title = _textFieldController.text;
                  titlesBox.add(Title(title));
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
  }
}

class AddNote extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final int topic;
  AddNote({Key key, @required this.topic}) : super(key: key); 

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  
  Box<Note> favNotesBox;
  Note name;
  Note text;
  TextEditingController _controller;
  
  
  
  int countera = 0;
  int counterb = 0;
  int counterc = 0;
  int counterx = 0;
  int indice = 0;
  int indiceb = 0;
  int indiceq = 0;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Lateral',
      style: optionStyle,
    ),
    Text(
      'Index 1: Vertical',
      style: optionStyle,
    ),
    Text(
      'Index 2: Beneath',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
      countera = countera + 1;
      onFormNav();
      _controller.text = name.content;
      }
      if (_selectedIndex == 2) {
      counterb = counterb + 1;  
      onFormNav();
      _controller.text = name.content;
      }
      if (_selectedIndex == 3) {
      counterc = counterc + 1;  
      onFormNav();
      _controller.text = name.content;
      }
      else {
      }
    });
  }


  void initState() {
    super.initState();
    _controller = new TextEditingController();
    indiceq = widget.topic;
    print(indiceq);
    indiceb = 1000*indiceq; 
    Box<Note> newNotesBox = Hive.box<Note>(notesBoxName);
    text = newNotesBox.get(indiceb);
    if ( text == null ) {
      print('no note');
      _controller.text = ''; 
     }
    else {
      _controller.text = text.content;
    }       
  }

  void onFormSave() {
    if (widget.formKey.currentState.validate()) {
      Box<Note> notesBox = Hive.box<Note>(notesBoxName);
      for( var i = 0; i < 2; i++) {
        for( var j = 0; j < 2; j++) {
          for( var k = 0; k < 2; k++) {
            for( var l = 0; l < 2; l++) {
              indice = 1000*counterx + 100*countera + 10*counterb + counterc; 
            }
          }
        }
      }
      notesBox.putAt(indice,Note(name.content));
    }
  }
  
  void onFormNav() async {
  if (widget.formKey.currentState.validate()) {
      Box<Note> notesBox = await Hive.box<Note>(notesBoxName);
      for( var i = 0; i < 2; i++) {
        for( var j = 0; j < 2; j++) {
          for( var k = 0; k < 2; k++) {
            for( var l = 0; l < 2; l++) {
              indice = 1000*counterx + 100*countera + 10*counterb + counterc; 
            }
          }
        }
      }
     name = notesBox.get(indice);
     if ( name == null ) {
      print('no note');
      _controller.text = ''; 
     }
    else {
      _controller.text = name.content;
    }
  }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.black54,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Add Lateral',
            onPressed: () {
               countera = countera + 1;
              setState(() {
                       
                        _controller.text = '';
                        counterx = widget.topic;
                       
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            tooltip: 'Add Vertical',
            onPressed: () {
              counterb = counterb + 1;
              setState(() {
                       
                        _controller.text = '';
                       
                      });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Beneath',
            onPressed: () {
              counterc = counterc + 1;
              setState(() {
                       
                        _controller.text = '';
                      
                      });
            },
          ),
          IconButton(
            icon: const Icon(Icons.description),
            tooltip: 'Show Slide Number',
            onPressed: () {
              showDialog(
                        context: context,
                        barrierDismissible: true,
                        child: AlertDialog(
                          content: Text(
                            'Lateral $countera \n Vertical $counterb \n Beneath $counterc',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Back"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  TextFormField(
                    controller: _controller,
                    autofocus: true,
                    maxLines: 12,
                    decoration: const InputDecoration(
                      labelText: "Note",
                    ),
                    onChanged: (value) {
                      setState(() {
                        name.content = value;
                        print(name.content); 
                        
                      });
                      onFormSave(); 
                  },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
         
          persistentFooterButtons: <Widget>[
          IconButton(icon: Icon(Icons.keyboard_arrow_left),onPressed: () {
          countera = countera - 1;
          onFormNav();
          }),
          
          IconButton(icon: Icon(Icons.keyboard_arrow_up),onPressed: () {
          countera = countera - 1;
          onFormNav();
          }),
          IconButton(icon: Icon(Icons.skip_previous),onPressed: () {
          counterb = counterb - 1;
          onFormNav();
          }),
          IconButton(icon: Icon(Icons.check),onPressed: () {
          onFormSave();  
          }),
         ],
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_arrow_right),
            title: Text('Lateral'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_arrow_down),
            title: Text('Vertical'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.skip_next),
            title: Text('Beneath'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TitleAdapter extends TypeAdapter<Title> {
  @override
  final typeId = 1;

  @override
  Title read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Title(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Title obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.caption);
  }
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 0;

  @override
  Note read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.content);
  }
}

