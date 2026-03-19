import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setAllFilters(Map<Filter, bool> allFilters) {
    state = allFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive;  // not allowed => mutating state
    state = {
      ...state,
      filter:
          isActive, //copy existing map ...state with spread operator and set one key to a new value
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
  (ref) => FilterNotifier(),
);

final filteredMealProvider = Provider((ref) {
  final dmeals = ref.watch(mealsProvider.notifier).state;
  final activeFilters = ref.watch(filtersProvider);
  return dmeals.where(
    (aMeal) {
      if (activeFilters[Filter.glutenFree]! && !aMeal.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filter.lactoseFree]! && !aMeal.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filter.vegetarian]! && !aMeal.isVegetarian) {
        return false;
      }
      if (activeFilters[Filter.vegan]! && !aMeal.isVegan) {
        return false;
      }
      return true;
    },
  ).toList();
});
