import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeImage extends StatelessWidget {
  const RecipeImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    const String defaultImage = 'assets/images/default.png';

    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      image: NetworkImage(imageUrl),
      fit: BoxFit.cover,
      height: 250,
      width: double.infinity,
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset(
          defaultImage,
          fit: BoxFit.cover,
          height: 250,
          width: double.infinity,
        );
      },
    );
  }
}
