import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

// 현재 사용하고 있는 디바이스의 영상과 관련된 패키지
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// 상대방과 관련된 패키지
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  // 아고라 api를 쓸때 컨트롤러처럼 사용하는 것
  RtcEngine? engine;
  int? uid;
  int? otherUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live"),
      ),
      body: FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          // 맨처음 실행 했을 때
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    renderMainView(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 160,
                        width: 120,
                        color: Colors.grey,
                        child: renderSubView(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (engine != null) {
                      await engine!.leaveChannel();
                    }
                  },
                  child: Text("채널 나가기"),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget renderSubView() {
    if (otherUid == null) {
      return Center(
        child: Text("채널에 유저가 없습니다."),
      );
    } else {
      return RtcRemoteView.SurfaceView(
        uid: otherUid!,
        channelId: CHANNEL_NAME,
      );
    }
    ;
  }

  Widget renderMainView() {
    if (uid == null) {
      return Center(
        child: Text("채널에 참여해 주세요"),
      );
    } else {
      return RtcLocalView.SurfaceView();
    }
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

    if (cameraPermission != PermissionStatus.granted ||
        microphonePermission != PermissionStatus.granted) {
      throw "카메라 또는 마이크 권한이 없습니다.";
    }

    if (engine == null) {
      RtcEngineContext context = RtcEngineContext(APP_ID);

      engine = await RtcEngine.createWithContext(context);

      engine!.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          // channel: 채널이름
          // uid : 0이라는 값을 넣어줬을 때 아고라api가 자동으로 할당해주는 아이디
          // elapsed : joinChannel을 요청해 join이 된 후 지난 시간 miliseconds
          print("채널에 입장했습니다. uid:${uid}");
          setState(() {
            this.uid = uid;
          });
        },
        leaveChannel: (state) {
          print("채널 퇴장");
          setState(() {
            this.uid = null;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("상대가 채널에서 나갔습니다.");
          setState(() {
            this.otherUid = null;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("상대가 채널에 입장했습니다. uid:${uid}");
          setState(() {
            this.otherUid = uid;
          });
        },
      ));

      // 비디오 활성화
      await engine!.enableVideo();
      // 채널에 들어가기
      // 마지막 인자는 중복되지 않는 유니크 숫자가 들어가야하는데 0으로 넣어주면 아고라 api가 자동으로 배정
      await engine!.joinChannel(
        TEMP_TOKEN,
        CHANNEL_NAME,
        null,
        0,
      );
    }

    return true;
  }
}
