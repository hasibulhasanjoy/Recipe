import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/widgets/recipe_details/ingredient_list.dart';
import 'package:recipe/widgets/recipe_details/recipe_image.dart';
import 'package:recipe/widgets/recipe_details/recipe_info.dart';
import 'package:recipe/widgets/recipe_details/recipe_steps.dart';
import 'package:recipe/widgets/recipe_details/timing_info.dart';
import 'package:recipe/widgets/recipe_details/title_icon.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailsScreen({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  Map<String, dynamic>? recipeDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  Future<void> fetchRecipeDetails() async {
    String apiKey = dotenv.env['spoonacular_api_key'] ?? '';

    final url =
        'https://api.spoonacular.com/recipes/${widget.recipeId}/information?apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          recipeDetails = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load recipe details');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  List<dynamic> transformIngredients(List<dynamic> extendedIngredients) {
    return extendedIngredients.map((ingredient) {
      return {
        'name': ingredient['name'], // Ingredient name
        'quantity':
            '${ingredient['amount']} ${ingredient['unit']}', // Amount with unit
      };
    }).toList();
  }

  List<String> extractSteps(List<dynamic> data) {
    List<String> result = [];
    for (var step in data[0]["steps"]) {
      result.add(step['step']);
    }
    return result;
  }

  Future<void> toggleFavorite() async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }

      final userId = user.uid; // Current user ID
      final favoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');

      final recipeId = widget.recipeId.toString(); // Recipe ID as a string

      // Check if the recipe is already in favorites
      final existingDoc = await favoritesRef.doc(recipeId).get();

      if (existingDoc.exists) {
        // Remove from favorites if already favorited
        await favoritesRef.doc(recipeId).delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe removed from favorites')),
          );
        }
      } else {
        // Add to favorites if not already favorited
        await favoritesRef.doc(recipeId).set({
          'id': recipeId,
          'title': recipeDetails!['title'],
          'imgUrl': recipeDetails!['image'],
          'timestamp': FieldValue.serverTimestamp(), // Optional
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe added to favorites')),
          );
        }
      }

      setState(() {}); // Refresh UI
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update favorites')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF48B04C),
              ),
            )
          : recipeDetails != null
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RecipeImage(imageUrl: recipeDetails!['image']),
                      RecipeTitleAndFavoriteIcon(
                        title: recipeDetails!['title'],
                        recipeId: widget.recipeId.toString(),
                        onToggleFavorite: toggleFavorite,
                      ),
                      RecipeInfo(
                        course: recipeDetails!['dishTypes'],
                        cuisine: recipeDetails!['cuisines'],
                        affordable: recipeDetails!['cheap'],
                      ),
                      TimingInfo(
                        preparationTime: recipeDetails!['preparationMinutes'],
                        cookingTime: recipeDetails!['cookingMinutes'],
                        totalTime: recipeDetails!['readyInMinutes'],
                      ),
                      IngredientList(
                        ingredients: transformIngredients(
                            recipeDetails!['extendedIngredients']),
                      ),
                      RecipeSteps(
                        steps: extractSteps(
                            recipeDetails!['analyzedInstructions']),
                      ),
                    ],
                  ),
                )
              : const Center(child: Text('Failed to load recipe details')),
    );
  }
}
