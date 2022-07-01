class User {
  String? id;
  String? passWord;
  String? token;

  User();

  toJson() {
    return {
      "id": id,
      "passWord": passWord,
      "token": token,
    };
  }

}