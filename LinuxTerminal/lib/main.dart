import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

var fs = FirebaseFirestore.instance;
var cmd;

class _MyAppState extends State<MyApp> {
  var data;
  web(i) async {
    var url = "http://192.168.29.26/cgi-bin/web.py?q=$i";
    var r = await http.get(url);

    setState(() {
      data = r.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            
            
            backgroundColor: Colors.black,
            elevation: 0,
            title: Center(
              child: Text(
                "My Terminal",
                style: GoogleFonts.abrilFatface(fontSize: 30 , color: Colors.green[400]),
              ),
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(13),
       
            padding: EdgeInsets.all(7),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.green,
                width: 5.0,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [new BoxShadow(
            color: Colors.black,
            blurRadius: 20.0,
          ),]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("[root@localhost]:",
                        style: GoogleFonts.montserrat(
                            fontSize: 20, color: Colors.white)),
                    Container(
                      width: 150,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: TextFormField(
                        onChanged: (value) {
                          cmd = value;
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 20,
                            color: Colors.green[300],
                          ),
                          onPressed: () async {
                            web(cmd);
                            await FirebaseFirestore.instance
                                .collection("Terminal_Output")
                                .add({
                              "output": data,
                            });
                          },
                        )),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    data ?? " ",
                    style: GoogleFonts.lato(color: Colors.green[300], fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
