import 'dart:convert';
import 'dart:io';
import 'package:dailymissions/screens/show_previous_day.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RecentDays extends StatefulWidget {
  static final String id = "recentdays";
  static Map<String, dynamic> jsonChosenFile;

  @override
  _RecentDaysState createState() => _RecentDaysState();
}

class _RecentDaysState extends State<RecentDays> {

  String dirAsString;
  List file = new List();
  List daysFiles = new List();
  List daysJsonFiles = new List();

  setDebute () async {
    dirAsString = (await getApplicationDocumentsDirectory()).path;

    setState(() {
      file = Directory("$dirAsString/").listSync();
    });

    for (int i = 0;i < file.length;i++)
      if (file[i].toString().contains("dayJson")) {
        initFiles(file[i].toString());
        getData(file[i]);
        daysFiles.add(file[i]);
      }
  }

  void initFiles (String path) {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(path);
      fileExists = jsonFile.existsSync();
      print(jsonFile);
      if (fileExists) this.setState(() => fileContent = json.decode(jsonFile.toString()));
    });
  }

  File jsonFile;
  Directory dir;
  String fileName;
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  getData(File path) async {
    String data;
    try {
      data = await path.readAsStringSync();
    } catch (e) {}

    final jsonResponse = jsonDecode(data);

    daysJsonFiles.add(jsonResponse);

    print("add ${daysJsonFiles[daysJsonFiles.length - 1]}");

    //print("add $jsonResponse"); //shows the full json string that I want.
  }

  @override
  void initState() {
    super.initState();
    setDebute();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text("List Of Days",style: TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold),),
        ),
        body: SafeArea(
          child: ListView.builder(
            itemExtent: MediaQuery.of(context).size.width / 3,
            itemCount: (daysFiles.length / 2).ceil(),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async{
                      RecentDays.jsonChosenFile = daysJsonFiles[index * 2];
                      Navigator.pushNamed(context, ShowPreviousDay.id);
                    },
                    child: Container(
                      height: 100,
                      width: 150,
                      child: Card(
                        color: Colors.yellowAccent[400],
                        child: Center(child: Text(daysJsonFiles[index * 2]['date'].toString().substring(0,10),style: TextStyle(fontSize: 25),)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(width: 3,color: Colors.black12),
                        ),
                      ),
                    ),
                  ),
                  index == (daysFiles.length / 2).ceil() - 1 && daysFiles.length % 2 == 0 || index != (daysFiles.length / 2).ceil() - 1
                      ? GestureDetector(
                    onTap: () async{
                      RecentDays.jsonChosenFile = daysJsonFiles[index * 2 + 1];
                      Navigator.pushNamed(context, ShowPreviousDay.id);
                    },
                    child: Container(
                      height: 100,
                      width: 150,
                      child: Card(
                        color: Colors.yellowAccent[400],
                        child: Center(child: Text(daysJsonFiles[index * 2 + 1]['date'].toString().substring(0,10),style: TextStyle(fontSize: 25),)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(width: 3,color: Colors.black12),
                        ),
                      ),
                    ),
                  ) : SizedBox(height: 0,width: 150,),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}