// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
void main() => runApp(MyApp());
 */

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //This widget is the root of our application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App 7",
      home: Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          title: Text("Text-field Widget"),
          //leading: Icon(Icons.home),
          backgroundColor: Colors.black,
        ),
         body: Column(
          children: [
            Text(
              "Hello from Anubhav. Trying to learn new things.",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                  //fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.white,
                  letterSpacing: 1.0,
                  wordSpacing: 5.0,
                  shadows: [
                    Shadow(
                      color: Colors.blue, offset: Offset(2.0, 2.0),
                    ),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  text: 'Hello!!',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Coders',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                      //recognizer:
                    ),
                  ]
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                obscureText: true,  //for passwords hiding
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name:',
                  hintText: 'Enter Your name',
                ),
              ),
            )
          ]
      ),
    ),
    );
  }
}
/*
Container(
          height: 100,
          width: 100,
          margin: EdgeInsets.all(20), //same margin given from all the 4 sides
          //padding: EdgeInsets.only(left: 10, top: 20, right: 30, bottom: 40),
          padding: EdgeInsets.all(20), //distance between child & container widget
          alignment: Alignment.center, //Placing text in the center of the container
          //color: Colors.blue,
          child: Text("Hey Coders!",style: TextStyle(fontSize: 15),),
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.orange, offset: Offset(6.0,6.0),
              )
            ]
          ),
          transform: Matrix4.rotationZ(0.1),
          //constraints: BoxConstraints.expand(height: 10.0),
        ),
*/

/*
body: Column(                         //use Row for horizontal
          //mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
            mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 50,
              width: 100,
              margin: EdgeInsets.all(10),
              color: Colors.orange,
              child: Text("Anubhav"),
            ),
            Container(
              height: 50,
              width: 100,
              margin: EdgeInsets.all(10),
              color: Colors.blue,
              child: Text("Hello"),
            ),
            Container(
              height: 50,
              width: 100,
              margin: EdgeInsets.all(10),
              color: Colors.pinkAccent,
              child: Text("Coders"),
            ),
          ]
        ),
*/
/*

*/