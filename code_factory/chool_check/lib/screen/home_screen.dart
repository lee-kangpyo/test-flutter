import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // lattitude - 위도, longitude - 경도
  static final LatLng companyLatLng = const LatLng(
    37.544790,
    127.059366,
  );

  static final CameraPosition initialPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );

  static final double distance = 100;
  // 반경 표시
  static final Circle withinDistanceCircle = Circle(
    circleId: const CircleId("withinDistanceCircle"),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: distance,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  static final Circle notwithinDistanceCircle = Circle(
    circleId: const CircleId("notwithinDistanceCircle"),
    center: companyLatLng,
    fillColor: Colors.red.withOpacity(0.5),
    radius: distance,
    strokeColor: Colors.red,
    strokeWidth: 1,
  );

  static final Circle checkDoneCircle = Circle(
    circleId: const CircleId("checkDoneCircle"),
    center: companyLatLng,
    fillColor: Colors.green.withOpacity(0.5),
    radius: distance,
    strokeColor: Colors.green,
    strokeWidth: 1,
  );

  static final Marker marker = Marker(
    markerId: MarkerId("marker"),
    position: companyLatLng,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == "위치 권한이 허가 되었습니다.") {
            return Column(
              children: [
                _CustomGoogleMap(
                  marker: marker,
                  initialPosition: initialPosition,
                  circle: withinDistanceCircle,
                ),
                const _choolCheckButton(),
              ],
            );
          }

          return Center(
            child: Text(snapshot.data),
          );
        },
      ),
    );
  }
  // end

  Future<String> checkPermission() async {
    // 단말기에서 위치정보 사용을 끈 상태인지 체크
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return "위치 서비스를 활성화 해주세요.";
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return "위치 권한을 허가해주세요.";
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return "앱의 위치 권한을 셋팅에서 허가해주세요.";
    }

    return "위치 권한이 허가 되었습니다.";
  }

  AppBar renderAppBar() {
    return AppBar(
      title: const Text(
        "오늘도 출근!",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final Circle circle;
  final Marker marker;

  const _CustomGoogleMap({
    required this.marker,
    required this.initialPosition,
    required this.circle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: Set.from([circle]),
        markers: Set.from([marker]),
      ),
    );
  }
}

class _choolCheckButton extends StatelessWidget {
  const _choolCheckButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Text("출근!"),
    );
  }
}
