import 'package:dailymissions/day_review.dart';
import 'package:dailymissions/models/missions.dart';
import 'package:dailymissions/models/monthly_weekly_missions.dart';
import 'package:dailymissions/models/previous_days.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class SQL_Helper {

  static SQL_Helper dbHelper;
  static Database _database;

  SQL_Helper._createInstance();

  factory SQL_Helper() {
    if (dbHelper == null) {
      dbHelper = SQL_Helper._createInstance();
    }
    return dbHelper;
  }

  String tableName = "missions";
  String _id = "id";
  String __name = "name";
  String __description = "description";
  String __status = "status";
  String __flex = "flex";

  String tableName2 = "dayreview";
  String _id2 = "id";
  String __category = "category";
  String __content = "content";

  String tableName3 = "previousdaysreviews";
  String _id3 = "id";
  String __date = "date";
  String __numberOfDays = "numberOfDays";

  String tableName4 = "plan";
  String _id4 = "id";
  String _planNumber = "num";

  String tableName5 = "monthlyweeklymissions";
  String _id5 = "id";
  String __status5 = "status";



  Future<Database> get database async {
    if (_database == null){
      _database = await initializedDatabase();
    }
    return _database;
  }


  Future<Database> initializedDatabase() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "databasedays.db";

    var missionsDB = await openDatabase(path, version: 1, onCreate: createDatabase);
    return missionsDB;
  }


  void createDatabase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName($_id INTEGER PRIMARY KEY AUTOINCREMENT, $__name TEXT, $__description TEXT," +
            " $__status INTEGER, $__flex INTEGER)");

    await db.execute(
        "CREATE TABLE $tableName2($_id2 INTEGER PRIMARY KEY AUTOINCREMENT, $__category TEXT, $__content TEXT)");

    await db.execute(
        "CREATE TABLE $tableName3($_id3 INTEGER PRIMARY KEY AUTOINCREMENT, $__date TEXT, $__numberOfDays INTEGER)");

    await db.execute(
        "CREATE TABLE $tableName4($_id4 INTEGER PRIMARY KEY AUTOINCREMENT, $_planNumber INTEGER)");

    /*await db.execute(
        "CREATE TABLE $tableName5($_id5 INTEGER PRIMARY KEY AUTOINCREMENT, $__name5 TEXT, $__description5 TEXT," +
            " $__status5 INTEGER)");*/
  }

  Future<List<Map<String, dynamic>>> getMissionsMapList() async {
    Database db = await this.database;

    //var result1 =  await db.rawQuery("SELECT * FROM $tableName ORDER BY $_id ASC");
    var result = await db.query(tableName, orderBy: "$_id ASC");
    return result;
  }

  Future<int> insertMission(Missions missions) async {
    Database db = await this.database;
    var result = await db.insert(tableName, missions.toMap());
    return result;
  }

  Future<int> updateMission(Missions missions) async{
    Database db = await this.database;
    var result = await db.update(tableName, missions.toMap(), where: "$_id = ?", whereArgs: [missions.id]);
    return result;
  }

  Future<int> updateStatusMission(Missions missions) async{
    Database db = await this.database;
    var result = await db.rawUpdate("UPDATE $tableName SET $__status = ? WHERE $_id = ? " , [missions.status,missions.id]);
    return result;
  }

  Future<int> deleteMission(int id) async {
    var db = await this.database;
    int result = await db.rawDelete("DELETE FROM $tableName WHERE $_id = $id");
    return result;
  }


  Future<List<Missions>> getMissionsList() async{

    var missionsMapList = await getMissionsMapList();
    int count = missionsMapList.length;

    List<Missions> missions = new List<Missions>();

    for (int i = 0; i <= count -1; i++){
      missions.add(Missions.getMap(missionsMapList[i]));
      print("${missions[i].id}  ${missions[i].name} ${missions[i].status}");
    }

    return missions;
  }

  Future<List<Map<String, dynamic>>> getReviewsMapList() async {
    Database db = await this.database;

    //var result1 =  await db.rawQuery("SELECT * FROM $tableName ORDER BY $_id ASC");
    var result = await db.query(tableName2, orderBy: "$_id2 ASC");
    return result;
  }

  Future<int> insertReview(DayReview dayReview) async {
    Database db = await this.database;
    var result = await db.insert(tableName2, dayReview.toMap());
    return result;
  }

  Future<int> updateReview(DayReview dayReview) async{
    Database db = await this.database;
    var result = await db.update(tableName2, dayReview.toMap(), where: "$_id2 = ?", whereArgs: [dayReview.id]);
    return result;
  }

  Future<int> updateReviewContent(DayReview dayReview) async{
    Database db = await this.database;
    var result = await db.rawUpdate("UPDATE $tableName2 SET $__content = ? WHERE $_id2 = ? " , [dayReview.content,dayReview.id]);
    return result;
  }

  Future<List<DayReview>> getReviewsList() async{

    var reviewsMapList = await getReviewsMapList();
    int count = reviewsMapList.length;

    List<DayReview> reviews = new List<DayReview>();

    for (int i = 0; i <= count -1; i++){
      reviews.add(DayReview.getMap(reviewsMapList[i]));
      print("${reviews[i].id}  ${reviews[i].category} ${reviews[i].content}");
    }

    return reviews;
  }



  Future<List<Map<String, dynamic>>> getPreviousDaysReviewsMapList() async {
    Database db = await this.database;

    //var result1 =  await db.rawQuery("SELECT * FROM $tableName ORDER BY $_id ASC");
    var result = await db.query(tableName3, orderBy: "$_id3 ASC");
    return result;
  }

  Future<int> insertPreviousDaysReviews(PreviousDaysReview previousDaysReview) async {
    Database db = await this.database;
    var result = await db.insert(tableName3, previousDaysReview.toMap());
    return result;
  }

  Future<List<PreviousDaysReview>> getPreviousDaysReviewsList() async{

    var previousDaysReviewsMapList = await getPreviousDaysReviewsMapList();
    int count = previousDaysReviewsMapList.length;

    List<PreviousDaysReview> previousReview = new List<PreviousDaysReview>();

    for (int i = 0; i <= count -1; i++){
      previousReview.add(PreviousDaysReview.getMap(previousDaysReviewsMapList[i]));
      print("${previousReview[i].id}  ${previousReview[i].date} ${previousReview[i].numberOfDays}");
    }

    return previousReview;
  }





  Future<List<int>> getPlanList() async {
    Database db = await this.database;

    //var result1 =  await db.rawQuery("SELECT * FROM $tableName ORDER BY $_id ASC");
    var result = await db.query(tableName4, orderBy: "$_id4 ASC");

    int count = result.length;

    List<dynamic> plans = new List<int>();

    for (int i = 0; i <= count -1; i++){
      plans.add(result[i]);
      print("${plans[i]}");
    }

    return plans;
  }

  Future<int> insertPlan(int id, int plan) async {
    Database db = await this.database;
    var result = await db.insert(tableName4, {"id": id,"num": plan});
    return result;
  }

  Future<int> updatePlan(int id, int plan) async{
    Database db = await this.database;
    var result = await db.update(tableName4, {"num": plan}, where: "$_id4 = ?", whereArgs: [id]);
    return result;
  }




  Future<List<Map<String, dynamic>>> getMWMissionsMapList() async {
    Database db = await this.database;

    //var result1 =  await db.rawQuery("SELECT * FROM $tableName ORDER BY $_id ASC");
    var result = await db.query(tableName5, orderBy: "$_id5 ASC");
    return result;
  }

  Future<int> insertMWMission(MonthlyWeeklyMissions mWMissions) async {
    Database db = await this.database;
    var result = await db.insert(tableName5, mWMissions.toMap());
    return result;
  }

  Future<int> updateMWMission(MonthlyWeeklyMissions mWMissions) async{
    Database db = await this.database;
    var result = await db.update(tableName5, mWMissions.toMap(), where: "$_id5 = ?", whereArgs: [mWMissions.id]);
    return result;
  }

  Future<int> updateStatusMWMission(MonthlyWeeklyMissions mWMissions) async{
    Database db = await this.database;
    var result = await db.rawUpdate("UPDATE $tableName5 SET $__status5 = ? WHERE $_id5 = ? " , [mWMissions.status,mWMissions.id]);
    return result;
  }

  Future<int> deleteMWMission(int id) async {
    var db = await this.database;
    int result = await db.rawDelete("DELETE FROM $tableName5 WHERE $_id5 = $id");
    return result;
  }


  Future<List<MonthlyWeeklyMissions>> getMWMissionsList() async{

    var mWMissionsMapList = await getMWMissionsMapList();
    int count = mWMissionsMapList.length;

    List<MonthlyWeeklyMissions> missions = new List<MonthlyWeeklyMissions>();

    for (int i = 0; i <= count -1; i++){
      missions.add(MonthlyWeeklyMissions.getMap(mWMissionsMapList[i]));
      print("${missions[i].id}  ${missions[i].name} ${missions[i].status}");
    }

    return missions;
  }



  void resetDB() async {
    Database db = await this.database;

    await db.delete(tableName);
    await db.delete(tableName2);
    await db.delete(tableName4);
  }
}