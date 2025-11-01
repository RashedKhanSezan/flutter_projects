import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/item_screen.dart';
import 'package:shopping_list/model/grocery_item.dart';
import 'package:http/http.dart' as http;

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;
  String? _errorMassege;

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    final url = Uri.https('flutter-prep-c90e9-default-rtdb.firebaseio.com',
        'myshopping-list.json');

    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _errorMassege = 'Failed to fetch data please try again later';
        });
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> list = jsonDecode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in list.entries) {
        final category = categories.entries
            .firstWhere((catItem) =>
                catItem.value.groceryType == item.value['category'])
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMassege = 'Something went wrong, Try out later';
      });
    }

    // print(response.statusCode);
  }

  void _addItem() async {
    final receivedItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) {
          return const ItemScreen();
        },
      ),
    );
    if (receivedItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(receivedItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final itemIndex = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https('flutter-prep-c90e9-default-rtdb.firebaseio.com',
        'myshopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(itemIndex, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('Trying Adding some Item in the list'),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_groceryItems[index].id),
            onDismissed: (swipdirection) {
              _removeItem(_groceryItems[index]);
            },
            child: ListTile(
              leading: Container(
                height: 30,
                width: 30,
                color: _groceryItems[index].category.groceryColor,
              ),
              title: Text(_groceryItems[index].name),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          );
        },
      );
    }
    if (_errorMassege != null) {
      content = Center(
        child: Text(_errorMassege!),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List App'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
