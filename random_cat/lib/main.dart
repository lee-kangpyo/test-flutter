import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CatService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

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

/// 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("랜덤 고양이"),
            backgroundColor: Colors.amber,
            actions: [
              // 좋아요 페이지로 이동
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritePage()),
                  );
                },
              )
            ],
          ),
          // 고양이 사진 목록
          body: GridView.count(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: EdgeInsets.all(8),
            crossAxisCount: 2,
            children: List.generate(
              catService.catImages.length, // 보여주려는 항목 개수
              (index) {
                String catImage = catService.catImages[index];
                return GestureDetector(
                  onTap: () {
                    // 사진 클릭시
                    catService.toggleFavoriteImage(catImage);
                  },
                  child: Stack(
                    children: [
                      Image.network(
                        catImage,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                          bottom: 8,
                          right: 8,
                          child: Icon(
                            Icons.favorite,
                            color: catService.favoriteImages.contains(catImage)
                                ? Colors.amber
                                : Colors.transparent,
                          ))
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// 좋아요 페이지
class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("좋아요"),
            backgroundColor: Colors.amber,
          ),
        );
      },
    );
  }
}
