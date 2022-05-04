import 'dart:async';

import 'package:dailymissions/missions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sql_helper.dart';

class MissionDetails extends StatefulWidget{
  static final String id = "missiondetails";

  String screenTitle;
  Missions missions;
  int choice;
  bool deletePossibility;

  MissionDetails(this.missions, this.screenTitle, this.choice, this.deletePossibility);

  @override
  State<StatefulWidget> createState() {
    return Mission(this.missions, screenTitle);
  }
}

class Mission extends State<MissionDetails> {
  bool response = false;

  static var _status = ["Done", "Not Yet"];
  String screenTitle;
  Missions missions;
  SQL_Helper helper = new SQL_Helper();

  Mission(this.missions,this.screenTitle);

  TextEditingController missionName = new TextEditingController();
  TextEditingController missionDetail = new TextEditingController();
  TextEditingController missionFlex = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    missionName.text = missions.name;
    missionDetail.text = missions.description;
    missionFlex.text = missions.flex.toString();

    return
      WillPopScope(
          onWillPop: () {
            goBack();
          },

          child: Scaffold(
            appBar: AppBar(
              title: Text(screenTitle),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  goBack();
                },
              ),
            ),

            body: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: DropdownButton(
                      items: _status.map((String dropDownItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownItem,
                          child: Text(dropDownItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPassing(missions.status),
                      onChanged: (selectedItem) {
                        setState(() {
                          setPassing(selectedItem);
                        });
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: missionName,
                      style: textStyle,
                      onChanged: (value) {
                        missions.name = value;
                      },
                      decoration: InputDecoration(
                          labelText: "Name :",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: missionDetail,
                      style: textStyle,
                      onChanged: (value) {
                        missions.description = value;
                      },
                      decoration: InputDecoration(
                          labelText: "Description :",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 155),
                    child: TextField(
                      controller: missionFlex,
                      style: textStyle.copyWith(fontSize: 25),
                      onChanged: (value) {
                        missions.flex = int.parse(value);
                      },
                      decoration: InputDecoration(
                          labelText: "Flex :",
                          labelStyle: textStyle.copyWith(fontSize: 25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            textColor: Theme
                                .of(context)
                                .primaryColorLight,
                            child: Text(
                              'SAVE', textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                helper.getMissionsList();
                                debugPrint("User Click SAVED");
                                _save();
                              });
                            },
                          ),
                        ),

                        Container(width: 5.0,),

                        Expanded(
                          child: RaisedButton(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            textColor: Theme
                                .of(context)
                                .primaryColorLight,
                            child:
                            Text(
                              'Delete', textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("User Click Delete");
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      );
  }

  List<Object> respon;

  void goBack() {
    respon = [true, response, widget.choice];
    Navigator.pop(context, respon);
  }

  void setPassing(String value) {
    switch(value) {
      case "Done":
        missions.status = 0;
        break;
      case "Not Yet":
        missions.status = 1;
        break;
    }
  }

  String getPassing(int value) {
    String status;
    switch(value){
      case 0:
        status = _status[0];
        break;
      case 1:
        status = _status[1];
        break;
    }

    return status;
  }

  void _save() async {
    int result;
    if (widget.choice == 1)
      result = await helper.insertMission(missions);
    else if (widget.choice == 3)
      result = await helper.updateMission(missions);

    if (result != 0) {
      print("mission added ${missions.id}");
      response = true;
    }

    goBack();

  }

  void _delete() async {
    if (missions.id == null){
      return;
    }

    if (widget.deletePossibility)
      await helper.deleteMission(missions.id);

    response = false;

    goBack();
  }

}