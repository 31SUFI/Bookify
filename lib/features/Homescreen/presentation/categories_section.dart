import 'package:flutter/material.dart';

class CategoriesSection extends StatefulWidget {
  final List<Category> categories;

  CategoriesSection({required this.categories});

  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: widget.categories.map((category) {
        return ChoiceChip(
          label: Text(category.label),
          selected: category.isSelected,
          onSelected: (bool selected) {
            setState(() {
              widget.categories.forEach((cat) {
                cat.isSelected = false;
              });
              category.isSelected = true;
            });
          },
          selectedColor: const Color.fromARGB(255, 174, 128, 1),
          backgroundColor: Colors.grey[200],
          labelStyle: TextStyle(
            color: category.isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}

class Category {
  String label;
  bool isSelected;

  Category({required this.label, this.isSelected = false});
}
