import 'package:flutter/material.dart';
import 'package:recipe/widgets/category_list.dart';

class RecipeCategoryList extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const RecipeCategoryList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks', 'Desserts'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return CategoryList(
            title: category,
            isSelected: selectedCategory == category,
            onTap: () => onCategorySelected(category),
          );
        }).toList(),
      ),
    );
  }
}
