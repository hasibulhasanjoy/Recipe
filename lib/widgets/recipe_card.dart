import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final void Function() onSelectMeal;

  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onSelectMeal,
  });

  @override
  Widget build(BuildContext context) {
    // Define the default image URL
    const String defaultImage = 'assets/images/default.png';

    return InkWell(
      onTap: () {
        onSelectMeal();
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                    imageUrl?.isNotEmpty == true ? imageUrl! : defaultImage),
                fit: BoxFit.cover,
                height: 120,
                width: double.infinity,
                imageErrorBuilder: (context, error, stackTrace) {
                  // Use the default image in case of an error loading the image
                  return Image.asset(
                    defaultImage,
                    fit: BoxFit.cover,
                    height: 120,
                    width: double.infinity,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
