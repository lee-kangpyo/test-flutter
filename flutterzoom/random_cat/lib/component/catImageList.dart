import 'package:flutter/material.dart';
import 'package:random_cat/cat_service.dart';

class catImageList extends StatelessWidget {
  final CatService catService;
  final String mode;
  const catImageList({
    Key? key,
    required this.catService,
    required this.mode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images =
        (mode == "home") ? catService.catImages : catService.favoriteImages;
    return GridView.count(
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      crossAxisCount: 2,
      children: List.generate(
        images.length, // 보여주려는 항목 개수
        (index) {
          String catImage = images[index];
          return GestureDetector(
            onTap: () {
              // 사진 클릭시
              catService.toggleFavoriteImage(catImage);
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    catImage,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite,
                    color: catService.favoriteImages.contains(catImage)
                        ? Colors.amber
                        : Colors.transparent,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
