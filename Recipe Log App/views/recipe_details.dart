import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_log/model/recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RecipeModel recipe = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                recipe.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.name,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("${recipe.cuisine} • ⭐ ${recipe.rating}",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 16)),
                      const SizedBox(height: 25),
                      const Text("Ingredients",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      
                      ...recipe.ingredients.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text("• $item",
                              style: const TextStyle(fontSize: 16)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
