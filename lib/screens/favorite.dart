import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/screens/recipe_details.dart';
import 'package:recipe/widgets/recipe_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  void _selectMeal(BuildContext context, String recipeId) {
    // Navigate to the recipe details screen with the selected recipe ID
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RecipeDetailsScreen(recipeId: int.parse(recipeId)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Favorite Recipes"),
          backgroundColor: const Color(0xFF48B04C),
        ),
        body: const Center(
          child: Text("Please log in to view your favorite recipes."),
        ),
      );
    }

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Recipes"),
        backgroundColor: const Color(0xFF48B04C),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: favoritesRef.snapshots(), // Listen for updates in real-time
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF48B04C),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("You have no favorite recipes."),
              );
            }

            // Extract favorite recipes
            final favoriteRecipes = snapshot.data!.docs;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe =
                    favoriteRecipes[index].data() as Map<String, dynamic>;

                return RecipeCard(
                  imageUrl:
                      recipe['imgUrl'], // Use the image URL from Firestore
                  title: recipe['title'], // Use the title from Firestore
                  onSelectMeal: () =>
                      _selectMeal(context, recipe['id'].toString()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
