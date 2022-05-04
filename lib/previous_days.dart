

class PreviousDaysReview {

  int _id;
  String _date;
  int _numberOfDays;

  PreviousDaysReview(this._date, this._numberOfDays);

  PreviousDaysReview.withId(this._id, this._date, this._numberOfDays);

  int get numberOfDays => _numberOfDays;

  String get date => _date;

  int get id => _id;

  set numberOfDays(int value) {
    _numberOfDays = value;
  }

  set date(String value) {
    _date = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = this._id;
    map["date"] = this._date;
    map["numberOfDays"] = this._numberOfDays;
    return map;
  }

  PreviousDaysReview.getMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._date = map["date"];
    this._numberOfDays = map["numberOfDays"];
  }
}