import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live"),
      ),
      body: FutureBuilder(
        future: init(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          // 맨처음 실행 했을 때
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: Text("권한이 있습니다."),
          );
        },
      ),
    );
  }

  Future<bool> init() async {
    final result = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = result[Permission.camera];
    final microphonePermission = result[Permission.microphone];

    /// 사용자가 요청한 기능에 대한 액세스를 거부했습니다. 또는 초기 상태
    //denied,

    /// 사용자가 요청한 기능에 대한 액세스 권한을 부여했습니다..
    //granted,

    /// OS가 요청한 기능에 대한 액세스를 거부했습니다. 사용자는 변경할 수 없습니다.
    /// 이 앱의 상태, 아마도 자녀 보호와 같은 활성 제한으로 인한 것일 수 있습니다.
    /// 제자리에 있는지 제어합니다.
    /// *iOS에서만 지원됩니다.*
    //restricted,

    /// 사용자가 제한된 액세스를 위해 이 애플리케이션을 승인했습니다.
    ///  *iOS(iOS14+)에서만 지원됩니다.*
    //limited,

    /// 요청한 기능에 대한 권한이 영구적으로 거부됨, 권한
    /// 이 권한을 요청할 때 대화 상자가 표시되지 않습니다.
    /// 사용자는 여전히 설정에서 권한 상태를 변경합니다
    /// *Android에서만 지원됩니다.*
    //permanentlyDenied,

    if(cameraPermission != PermissionStatus.granted ||
      microphonePermission != PermissionStatus.granted) {
      throw "카메라 또는 마이크 권한이 없습니다.";
    }

    return true;
  }
}
