class UserObject {
  String? name;
  String? email;
  String? pass;
  String? token;
  String? accountType;
  String? matricNumber;
  UserObject(
      {this.name,
      this.email,
      this.pass,
      this.token,
      this.accountType,
      this.matricNumber});
  //Tojson
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "pass": pass,
      "token": token,
      "account_type": accountType,
      "Matric": matricNumber,
    };
  }

  //Fromjson
  factory UserObject.fromJson(Map<String, dynamic>? json) {
    return UserObject(
      name: json?['name'],
      email: json?['email'],
      pass: json?['pass'],
      token: json?['token'],
      matricNumber: json?['Matric'],
      accountType: json?['account_type'] ?? "",
    );
  }
  @override
  String toString() {
    return 'UserObject{ name: $name, email: $email, password: $pass, token: $token, account_type: $accountType, Matric: $matricNumber}';
  }
}
