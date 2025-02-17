class UserDataModel {
  int? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? password;
  String? phone;
  String? image;
  String? dob;
  String? type;
  String? token;

  UserDataModel({
    this.id,
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.password,
    this.phone,
    this.image,
    this.dob,
    this.type,
    this.token,
  });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    image = json['image'];
    dob = json['dob'];
    type = json['type'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userName'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['image'] = image;
    data['dob'] = dob;
    data['type'] = type;
    data['token'] = token;
    return data;
  }
}
