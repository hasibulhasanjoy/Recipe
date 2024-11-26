import 'package:flutter/material.dart';

class RecipeInfo extends StatelessWidget {
  const RecipeInfo({
    super.key,
    required this.course,
    required this.cuisine,
    required this.affordable,
  });
  final List<dynamic> course;
  final List<dynamic> cuisine;
  final bool affordable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InfoItem(
            label: 'Course:',
            value: course.isNotEmpty ? course[0] : 'Main Course',
          ),
          InfoItem(
            label: 'Cuisine:',
            value: cuisine.isNotEmpty ? cuisine[0] : 'General',
          ),
          InfoItem(label: 'Affordable', value: affordable ? "Yes" : "No"),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
