import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecipeTitleAndFavoriteIcon extends StatelessWidget {
  final String title;
  final String recipeId;
  final VoidCallback onToggleFavorite;

  const RecipeTitleAndFavoriteIcon({
    super.key,
    required this.title,
    required this.recipeId,
    required this.onToggleFavorite,
  });

  Future<bool> isFavorite(String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(recipeId)
        .get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isFavorite(recipeId),
      builder: (context, snapshot) {
        final isInFavoriteList = snapshot.data ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Add padding to the Row
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(
                  isInFavoriteList ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        );
      },
    );
  }
}
