import 'dart:io';
import 'package:path_provider/path_provider.dart';

void writeCstco (String cstCo) async {
  var dir = await getApplicationDocumentsDirectory();
  File(dir.path + '/count.txt').writeAsStringSync(cstCo);
}

Future<String?> readCstco () async {
  try{
    var dir = await getApplicationDocumentsDirectory();
    String cstCo = await File(dir.path + '/count.txt').readAsString();
    print(cstCo);
    return cstCo;
  } catch(e){
    print(e.toString());
  }
}

void writeStr (String key, String value) async {
  var dir = await getApplicationDocumentsDirectory();
  File(dir.path + '/${key}.txt').writeAsStringSync(value);
}

Future<String?> readStr (String key) async {
  try{
    var dir = await getApplicationDocumentsDirectory();
    String value = await File(dir.path + '/${key}.txt').readAsString();
    return value;
  } catch(e){
    print(e.toString());
  }
}