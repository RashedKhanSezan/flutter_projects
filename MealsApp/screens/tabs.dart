import 'package:flutter/material.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_providers.dart';

// const Map<Filter, bool> kInitialFilters = {
//   Filter.glutenFree: false,
//   Filter.lactoseFree: false,
//   Filter.vegetarian: false,
//   Filter.vegan: false,
// };

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _onTapTiles(String aValue) async {
    Navigator.of(context).pop();
    if (aValue == 'Filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => const FiltersScreen(),
        ),
      );

      // // print(result);
      // setState(() {
      //   _selectedFilters = result ?? kInitialFilters;
      // });
    }
  }

  // void _showAMassageForPressed(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(message),
  //     duration: const Duration(milliseconds: 1),
  //   ));
  // }

  // void _toggleFavoriteMealStatus(Meal aMeal) {
  //   final isExisting = _favoriteMeals.contains(aMeal);

  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals.remove(aMeal);
  //     });
  //     _showAMassageForPressed('Favorite removed');
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(aMeal);
  //     });
  //     _showAMassageForPressed('Favorite added');
  //   }
  // }

  void _selectedIndex(int value) {
    setState(() {
      _selectedPageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeal = ref.watch(filteredMealProvider);

    Widget activePage = CategoriesScreen(
      availableMeals: filteredMeal,
    );

    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);

      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onTaptileFunction: _onTapTiles),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPageIndex,
          onTap: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Category'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorite'),
          ]),
    );
  }
}
