class Todo{
  Todo({this.title, this.content, this.active, this.id});

  String? title;
  String? content;
  bool? active;
  int? id;


  Map<String, dynamic> toMap(){
    return{
      "id":id,
      "title":title,
      "content":content,
      "active":active,
    };
  }
}