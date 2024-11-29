import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  const IngredientList({
    super.key,
    required this.ingredients,
  });

  final List<dynamic> ingredients;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Ingredients" heading
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16), // Space below the heading

          // List of ingredients
          ...ingredients.map(
            (ingredient) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ingredient['name']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      ingredient['quantity']!,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
