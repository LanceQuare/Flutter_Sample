class Category {
  int _id;
  int _parent;
  String _name;

  Category(this._name);

  Category.withId(this._id, this._name, [this._parent]);

  String get name => _name;

  int get parent => _parent;

  int get id => _id;

  set name(String name) {
    this._name = name;
  }

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['parent'] = _parent;

    return map;
  }

  Category.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._parent = map['parent'];
  }
}