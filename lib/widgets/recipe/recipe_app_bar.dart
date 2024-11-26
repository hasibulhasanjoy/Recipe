import 'package:flutter/material.dart';

class RecipeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final ValueChanged<bool> onSearchToggle;
  final ValueChanged<String> onSearch;

  const RecipeAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchToggle,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isSearching
            ? TextField(
                key: const ValueKey('SearchBar'),
                controller: searchController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      onSearchToggle(false);
                      searchController.clear();
                      onSearch('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: onSearch,
              )
            : const Text("Find Your Recipes"),
      ),
      actions: [
        if (!isSearching)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => onSearchToggle(true),
          ),
      ],
      backgroundColor: const Color(0xFF48B04C),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
