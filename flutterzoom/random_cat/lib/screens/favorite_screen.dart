import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_cat/cat_service.dart';
import 'package:random_cat/component/catImageList.dart';

/// 좋아요 페이지
class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("좋아요"),
            backgroundColor: Colors.amber,
          ),
          body: catImageList(
            catService: catService,
            mode: "favor",
          ),
        );
      },
    );
  }
}
