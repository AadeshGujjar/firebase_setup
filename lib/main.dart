import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_setup/model/board.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Board',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<Board> boardMessages = List();
  Board board;

// creating an instance of a database with whih we can access the DB.
  final FirebaseDatabase database = FirebaseDatabase.instance;

  //To create a form which will contain various text fields inside it.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState(){
    super.initState();// so that super class is able to initiate all its states and take
    // care of everything that needs to be taken care of.

    board=Board("","");
    databaseReference= database.reference().child("community_board");
    // to get a call every time a child/item is added to the database.
    databaseReference.onChildAdded.listen(_onEntryAdded);
  }





//  void _incrementCounter() {
//    //1) got reference to our database. 2)added a child. 3) Set it to tree with key "firstname" and value "Aadesh"
////    database.reference().child("message").once().then((DataSnapshot snapshot){//.once because we want to read it once
////      //because the data is stored in the form of a map in DB
////      Map<dynamic,dynamic> list=snapshot.value;
////      print("Values from DB ${list.values}");
////    });

//    setState(() {
//      _counter++;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Board"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Center(

              child: Form(
                key: formKey,
                child:  Flex(,
                direction: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.subject),
                    title: TextFormField(
                      initialValue: "",
                      onSaved: (val)=>board.subject=val,
                      validator: (val)=> val==""?val:null,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: TextFormField(
                      initialValue: "",
                      onSaved: (val)=>board.body=val,
                      validator: (val)=>val==""?val:null,
                    ),
                  ),
                  FlatButton(
                    child: Text("Post"),
                    color: Colors.redAccent,
                    onPressed: (){
                      handleSubmit();
                    },
                  )
                ],
              ),
            ),
          ),
    ),
          Flexible(
            child: FirebaseAnimatedList(
              query: databaseReference,//holds the data from our DB
              itemBuilder: (_,DataSnapshot snapshot, Animation<double> animation,int index){
                return new Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                    ),
                    title: Text(boardMessages[index].subject),
                    subtitle: Text(boardMessages[index].body),
                  ),
                );
              },
            ),
          )
        ],
      )
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      boardMessages.add(Board.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmit() {
    //getting the current state of our form. Weather empty or with Data filled.
    final FormState form= formKey.currentState;
    if(form.validate()){
      form.save();
      form.reset();

      //save from data to the DB   //passing in the object that we created
      databaseReference.push().set(board.toJson());
    }
  }
}
