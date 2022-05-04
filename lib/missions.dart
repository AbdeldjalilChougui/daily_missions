

class Missions {

  int _id;
  String _name;
  String _description;
  int _status;
  int _flex;

  Missions(this._name, this._description, this._status, this._flex);

  Missions.withId(this._id, this._name, this._description, this._status, this._flex);

  int get status => _status;

  String get description => _description;

  String get name => _name;

  int get id => _id;

  int get flex => _flex;

  set status(int value) {
    this._status = value;
  }

  set flex(int value) {
    this._flex = value;
  }

  set description(String value) {
    if (value.length <= 255) {
      _description = value;
    }
  }

  set name(String value) {
    if (value.length <= 255) {
      _name = value;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = this._id;
    map["name"] = this._name;
    map["description"] = this._description;
    map["status"] = this._status;
    map["flex"] = this._flex;
    return map;
  }

  Missions.getMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._name = map["name"];
    this._description = map["description"];
    this._status = map["status"];
    this._flex = map["flex"];
  }
}