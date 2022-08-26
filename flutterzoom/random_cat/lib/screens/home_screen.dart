import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_cat/component/catImageList.dart';
import 'package:random_cat/screens/favorite_screen.dart';

import '../cat_service.dart';

/// 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: const Text("랜덤 고양이"),
            actions: [goFavorBtn(context)],
          ),
          body: catImageList(catService: catService, mode: "home"),
        );
      },
    );
  }


  IconButton goFavorBtn(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.favorite),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritePage()),
        );
      },
    );
  }
}
