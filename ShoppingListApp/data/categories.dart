import 'package:flutter/material.dart';
import 'package:shopping_list/model/category.dart';

const categories = {
  Item.vegetables: Category(
    'Vegetable',
    Color.fromARGB(255, 0, 255, 128),
  ),
  Item.fruit: Category(
    'Fruit',
    Color.fromARGB(255, 145, 255, 0),
  ),
  Item.meat: Category(
    'Meat',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Item.dairy: Category(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
  ),
  Item.carbs: Category(
    'Carbs',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Item.sweets: Category(
    'Sweets',
    Color.fromARGB(255, 255, 149, 0),
  ),
  Item.spices: Category(
    'Spices',
    Color.fromARGB(255, 255, 187, 0),
  ),
  Item.convenience: Category(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
  ),
  Item.hygiene: Category(
    'Hygiene',
    Color.fromARGB(255, 149, 0, 255),
  ),
  Item.other: Category(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
  ),
};
