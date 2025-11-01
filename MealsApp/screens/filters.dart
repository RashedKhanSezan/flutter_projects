import 'package:flutter/material.dart';

// import 'package:meals/screens/tabs.dart';
// import 'package:meals/widgets/main_drawer.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/filters_providers.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

//   @override
//   ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
// }

// class _FiltersScreenState extends ConsumerState<FiltersScreen> {
//   var _glutenFreeFilterSet = false;
//   var _lactoseFreeFilterSet = false;
//   var _vegetarianFilterSet = false;
//   var _veganFilterSet = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _glutenFreeFilterSet = widget.currentFilters[Filter.glutenFree];
  //   _lactoseFreeFilterSet = widget.currentFilters[Filter.lactoseFree];
  //   _vegetarianFilterSet = widget.currentFilters[Filter.vegetarian];
  //   _veganFilterSet = widget.currentFilters[Filter.vegan];
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   final activeFilters = ref.read(filtersProvider);
  //   _glutenFreeFilterSet = activeFilters[Filter.glutenFree]!;
  //   _lactoseFreeFilterSet = activeFilters[Filter.lactoseFree]!;
  //   _vegetarianFilterSet = activeFilters[Filter.vegetarian]!;
  //   _veganFilterSet = activeFilters[Filter.vegan]!;
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(filtersProvider);

    return Scaffold(
      // drawer: MainDrawer(onTaptileFunction: (aValue) {
      //   Navigator.of(context).pop();
      //   if (aValue == 'Meals') {
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(
      //         builder: (context) => const TabsScreen(),
      //       ),
      //     );
      //   }
      // }),

      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      body:

          // WillPopScope(
          //   onWillPop: () async {
          //     ref.read(filtersProvider.notifier).setAllFilters({
          //       Filter.glutenFree: _glutenFreeFilterSet,
          //       Filter.lactoseFree: _lactoseFreeFilterSet,
          //       Filter.vegetarian: _vegetarianFilterSet,
          //       Filter.vegan: _veganFilterSet,
          //     });
          //     // Navigator.of(context).pop();
          //     // return false;

          //     return true;
          //   },
          //   child:

          Column(
        children: [
          SwitchListTile(
            value: activeFilter[Filter.glutenFree]!,
            onChanged: (aBoolValue) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.glutenFree, aBoolValue);
            },
            title: Text(
              'Gluten-Free',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              'Only includes gluten free meals.',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 20),
          ),
          SwitchListTile(
            value: activeFilter[Filter.lactoseFree]!,
            onChanged: (aBoolValue) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.lactoseFree, aBoolValue);
            },
            title: Text(
              'Lactose-Free',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              'Only includes lactose free meals.',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 20),
          ),
          SwitchListTile(
            value: activeFilter[Filter.vegetarian]!,
            onChanged: (aBoolValue) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegetarian, aBoolValue);
            },
            title: Text(
              'Vegetarian',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              'Only includes vegetarian meals.',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 20),
          ),
          SwitchListTile(
            value: activeFilter[Filter.vegan]!,
            onChanged: (aBoolValue) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegan, aBoolValue);
            },
            title: Text(
              'Vegan',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              'Only includes vegan meals.',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 20),
          ),
        ],
      ),
    );
  }
}
