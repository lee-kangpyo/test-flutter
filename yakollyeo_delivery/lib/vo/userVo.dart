class User {
  String? id;
  String? passWord;

  User();

  toJson(){
    return{
      "id":id,
      "passWord":passWord,
    };
  }
}