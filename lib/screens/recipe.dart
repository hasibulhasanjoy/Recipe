import 'package:flutter/material.dart';
import 'package:recipe/widgets/recipe/recipe_app_bar.dart';
import 'package:recipe/widgets/recipe/recipe_category_list.dart';
import 'package:recipe/widgets/recipe/recipe_grid.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';
  int _currentPage = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = '';
      } else {
        _selectedCategory = category;
      }
      _currentPage = 1;
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _selectedCategory = '';
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RecipeAppBar(
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchToggle: (bool isSearching) {
          setState(() => _isSearching = isSearching);
        },
        onSearch: _handleSearch,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          RecipeCategoryList(
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RecipeGrid(
              selectedCategory: _selectedCategory,
              searchQuery: _isSearching ? _searchController.text.trim() : '',
              currentPage: _currentPage,
              onLoadMore: () => setState(() => _currentPage++),
            ),
          ),
        ],
      ),
    );
  }
}
