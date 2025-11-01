import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/model/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/model/grocery_item.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});
  @override
  State createState() => _ItemScreenState();
}

class _ItemScreenState extends State {
  var _selectedName = '';
  var _selectedQuantity = 1;
  var _selectedCategory = categories[Item.vegetables]!;
  bool _isSaving = false;

  final _formKey = GlobalKey<FormState>();

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSaving = true;
      });
      final url = Uri.https('flutter-prep-c90e9-default-rtdb.firebaseio.com',
          'myshopping-list.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'name': _selectedName,
            'quantity': _selectedQuantity,
            'category': _selectedCategory.groceryType,
          },
        ),
      );

      final Map<String, dynamic> resData = jsonDecode(response.body);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(
        GroceryItem(
            id: resData['name'],
            name: _selectedName,
            quantity: _selectedQuantity,
            category: _selectedCategory),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (givenValue) {
                  if (givenValue == null ||
                      givenValue.isEmpty ||
                      givenValue.trim().length <= 2 ||
                      givenValue.trim().length > 50) {
                    return 'Between 2 and 50 characters';
                  }
                  return null;
                },
                onSaved: (givenName) {
                  _selectedName = givenName!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: _selectedQuantity.toString(),
                      validator: (givenValue) {
                        if (givenValue == null ||
                            givenValue.isEmpty ||
                            int.tryParse(givenValue) == null ||
                            int.tryParse(givenValue)! <= 0) {
                          return 'Must be valid positive number';
                        }
                        return null;
                      },
                      onSaved: (givenQuantity) {
                        _selectedQuantity = int.parse(givenQuantity!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final c in categories.entries)
                          DropdownMenuItem(
                            value: c.value,
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  color: c.value.groceryColor,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(c.value.groceryType),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (ashownValue) {
                        setState(() {
                          _selectedCategory = ashownValue!;
                        });
                        //setstate
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Cancle'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveItem,
                    child: _isSaving
                        ? const SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
