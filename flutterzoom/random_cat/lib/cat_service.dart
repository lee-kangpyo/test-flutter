

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

/// 고양이 서비스
class CatService extends ChangeNotifier {
  // 고양이 사진 담을 변수
  List<String> catImages = [];

  List<String> favoriteImages = [];

  // 생성자(Constructor)
  CatService() {
    getRandomCatImages(); // api 호출
  }

  /// 랜덤 고양이 사진 API 호출
  void getRandomCatImages() async {
    var result = await Dio().get(
      "https://api.thecatapi.com/v1/images/search?limit=10&mime_types=jpg",
    );
    for (int i = 0; i < result.data.length; i++) {
      var map = result.data[i]; // 반복문을 돌며 i번째의 map에 접근
      catImages.add(map['url']); // catImages에 이미지 추가
    }

    notifyListeners(); // 새로고침
  }

  // 좋아요 토글
  void toggleFavoriteImage(String catImage) {
    if (favoriteImages.contains(catImage)) {
      favoriteImages.remove(catImage); // 이미 좋아요한 경우 제거
    } else {
      favoriteImages.add(catImage); // 새로운 사진 추가
    }
    notifyListeners(); // 새로고침
  }
}