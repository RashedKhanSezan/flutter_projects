import 'package:get/get.dart';
import 'package:recipe_log/views/recipe.dart';

void main() => runApp(const RecipeLog());

class RecipeLog extends StatelessWidget {
  const RecipeLog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const RecipeScreen(),
    );
  }
}
