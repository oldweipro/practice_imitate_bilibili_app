class Owner {
  String name;
  String face;
  int fans;

  Owner({this.name, this.face, this.fans});
  // map转mo
  Owner.fromMap(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'];
  }
  // mo转map
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map();
    data['name'] = this.name;
    data['face'] = this.face;
    data['fans'] = this.fans;
    return data;
  }
}
