import 'package:flutter/material.dart';
import 'package:recipe_log/model/recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTapRecipe;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTapRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapRecipe,
      //  () {
      //   Get.to(() => RecipeDetailScreen(), arguments: recipe);
      // },
      child: Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(recipe.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.9), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "${recipe.rating} stars",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.timer_outlined,
                      color: Colors.white70, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "25 min",
                    style: const TextStyle(color: Colors.white70),
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
