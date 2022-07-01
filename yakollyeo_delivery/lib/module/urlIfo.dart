
  var NP = {
    //"host":"192.168.0.100:8080",
    "host":"admin.yakollyeo.com",
    "path":{
      "login":"/api/v1/login.do",
      "preOrder":"/api/v1/preOrder.do",
      "newOrder":"/api/v1/newOrder.do",
      "submitNewOrder":"/api/v1/submitNewOrder.do",
      "reqShipping":"/api/v1/reqShipping.do",
    },
  };

  String getHost (){
    return NP["host"] as String;
  }

  String getUrlPath (String pathName){
    Map<String, String> path =  NP["path"] as Map<String, String>;
    return path[pathName]!;
  }


