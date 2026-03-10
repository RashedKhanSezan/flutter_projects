import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_log/model/recipe_model.dart';

class RecipeController extends GetxController {
  var recipes = <RecipeModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchRecipe();
    super.onInit();
  }

  void fetchRecipe() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('https://dummyjson.com/recipes'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        var list = (data['recipes'] as List)
            .map((item) => RecipeModel.fromJson(item))
            .toList();
        recipes.assignAll(list);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load');
    } finally {
      isLoading(false);
    }
  }
}
