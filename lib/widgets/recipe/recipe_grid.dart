import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/screens/recipe_details.dart';
import 'package:recipe/widgets/recipe_card.dart';

class RecipeGrid extends StatefulWidget {
  final String selectedCategory;
  final String searchQuery;
  final int currentPage;
  final VoidCallback onLoadMore;

  const RecipeGrid({
    super.key,
    required this.selectedCategory,
    required this.searchQuery,
    required this.currentPage,
    required this.onLoadMore,
  });

  @override
  State<RecipeGrid> createState() => _RecipeGridState();
}

class _RecipeGridState extends State<RecipeGrid> {
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;

  int _scrollCount = 0;
  final int _maxScrolls = 2;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  @override
  void didUpdateWidget(covariant RecipeGrid oldWidget) {
    if (widget.selectedCategory != oldWidget.selectedCategory ||
        widget.searchQuery != oldWidget.searchQuery ||
        widget.currentPage != oldWidget.currentPage) {
      _fetchRecipes();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _selectMeal(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RecipeDetailsScreen(recipeId: id),
      ),
    );
  }

  Future<void> _fetchRecipes() async {
    if (_scrollCount > _maxScrolls) return;

    String apiKey = dotenv.env['spoonacular_api_key'] ?? '';

    final offset = (widget.currentPage - 1) * 30;
    final url = widget.searchQuery.isEmpty
        ? 'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&number=30&offset=$offset'
        : 'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&number=30&query=${widget.searchQuery}&offset=$offset';

    try {
      setState(() => _isLoading = true);

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          if (widget.currentPage == 1) {
            _recipes = data['results'];
          } else {
            _recipes.addAll(data['results']);
          }
          _isLoading = false;
          _isFetchingMore = false;
        });
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.currentPage == 1) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF48B04C)),
      );
    }

    if (_recipes.isEmpty) {
      return const Center(
        child: Text('No recipes found'),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            !_isFetchingMore &&
            _scrollCount < _maxScrolls) {
          _scrollCount++;
          widget.onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _recipes.length + (_isFetchingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _recipes.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final recipe = _recipes[index];
          return RecipeCard(
            imageUrl: recipe['image'],
            title: recipe['title'],
            onSelectMeal: () => _selectMeal(context, recipe['id']),
          );
        },
      ),
    );
  }
}
