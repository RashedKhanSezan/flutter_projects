import 'package:flutter/material.dart';

enum Item {
  vegetables,
  fruit,
  dairy,
  meat,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}

class Category {
  const Category(
    this.groceryType,
    this.groceryColor,
  );

  final String groceryType;
  final Color groceryColor;
}
