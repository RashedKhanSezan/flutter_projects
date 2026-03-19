import 'package:flutter/material.dart';
import 'package:recipe_log/controllers/recipe_controller.dart';
import 'package:get/get.dart';
import 'package:recipe_log/views/recipe_details.dart';
import 'package:recipe_log/widgets/recipe_card.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecipeController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 244),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 250, 244),
        title: Text(
          'RecipeLog',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 32,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: FractionallySizedBox(
                  widthFactor: .8,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search Recipe, Ingredients...'),
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.list))
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.recipes.length,
                itemBuilder: (context, index) {
                  final currentRecipe = controller.recipes[index];
                  return RecipeCard(
                    onTapRecipe: () {
                      Get.to(() => RecipeDetailScreen(),
                          arguments: currentRecipe);
                    },
                    recipe: currentRecipe,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
