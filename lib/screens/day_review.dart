

class DayReview {

  int _id;
  String _category;
  String _content;

  DayReview(this._category, this._content);

  DayReview.withId(this._id, this._category, this._content);

  String get content => _content;

  String get category => _category;

  int get id => _id;

  set content(String value) {
    if (value.length <= 255) {
      _content = value;
    }
  }

  set category(String value) {
    if (value.length <= 255) {
      _category = value;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = this._id;
    map["category"] = this._category;
    map["content"] = this._content;
    return map;
  }

  DayReview.getMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._category = map["category"];
    this._content = map["content"];
  }
}