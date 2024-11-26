import 'package:flutter/material.dart';

class TimingInfo extends StatelessWidget {
  const TimingInfo({
    super.key,
    this.preparationTime,
    this.cookingTime,
    this.totalTime,
  });

  final int? preparationTime;
  final int? cookingTime;
  final int? totalTime;

  // Getter for preparationTime as a string
  String get preparationTimeString {
    return preparationTime?.toString() ?? "0";
  }

  // Getter for cookingTime as a string
  String get cookingTimeString {
    return cookingTime?.toString() ?? "0";
  }

  // Getter for totalTime as a string
  String get totalTimeString {
    return totalTime?.toString() ?? "0";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InfoColumn('Prep time', '$preparationTimeString mins'),
          InfoColumn('Cooking time', '$cookingTimeString mins'),
          InfoColumn('Total time', '$totalTimeString mins'),
        ],
      ),
    );
  }
}

class InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const InfoColumn(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
