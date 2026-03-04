class RecipeModel {
  final int id;
  final String name;
  final List<String> ingredients;
  final String image;
  final double rating;
  final String cuisine;

  RecipeModel({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.image,
    required this.rating,
    required this.cuisine,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
        id: json["id"],
        name: json["name"],
        ingredients: List.from((json["ingredients"])),
        image: json["image"],
        rating: json["rating"] as double,
        cuisine: json["cuisine"]);
  }
}
