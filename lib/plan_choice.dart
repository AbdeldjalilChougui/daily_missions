import 'package:dailymissions/day_missions.dart';
import 'package:dailymissions/first_screen.dart';
import 'package:dailymissions/main.dart';
import 'package:dailymissions/sql_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanChoice extends StatefulWidget {
  static final String id = "planchoice";

  @override
  _PlanChoiceState createState() => _PlanChoiceState();
}

class _PlanChoiceState extends State<PlanChoice> {
  SQL_Helper helper = new SQL_Helper();

  bool isSelected = false;
  bool isSelected2 = false;
  bool isSelected3 = false;
  bool isSelected4 = false;

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
          title: Text("Choose A Plan",style: TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold),),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async{
                      MyApp.plan = 1;
                      await helper.insertPlan(1, 1);
                      Navigator.pop(context);
                      MyApp.walking++;
                      Navigator.pushNamed(context, DayMissions.id);
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Card(
                        color: Colors.yellowAccent[400],
                        child: Center(child: Text("Plan Dev",style: TextStyle(fontSize: 30),)),
                        shape: CircleBorder(
                            side: BorderSide(width: 3,color: Colors.black12)
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                      MyApp.plan = 2;
                      await helper.insertPlan(1, 2);
                      Navigator.pop(context);
                      MyApp.walking++;
                      Navigator.pushNamed(context, DayMissions.id);
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Card(
                        color: Colors.brown[400],
                        child: Center(child: Text(" Dev.1\n(sans)",style: TextStyle(fontSize: 30),)),
                        shape: CircleBorder(
                            side: BorderSide(width: 3,color: Colors.black12)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 50,width: 150,),
                  SizedBox(height: 50,width: 150,)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async{
                      MyApp.plan = 3;
                      await helper.insertPlan(1, 3);
                      Navigator.pop(context);
                      MyApp.walking++;
                      Navigator.pushNamed(context, DayMissions.id);
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Card(
                        color: Colors.blue[200],
                        child: Center(child: Text("Plan GD",style: TextStyle(fontSize: 30),)),
                        shape: CircleBorder(
                            side: BorderSide(width: 3,color: Colors.black12)
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                      MyApp.plan = 4;
                      await helper.insertPlan(1, 4);
                      Navigator.pop(context);
                      MyApp.walking++;
                      Navigator.pushNamed(context, DayMissions.id);
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Card(
                        color: Colors.purple[100],
                        child: Center(child: Text(" GD.1\n(sans)",style: TextStyle(fontSize: 30),)),
                        shape: CircleBorder(
                            side: BorderSide(width: 3,color: Colors.black12)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
