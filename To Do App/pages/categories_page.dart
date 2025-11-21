import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_category.dart';
import '../providers/task_provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final primaryColor = Theme.of(context).colorScheme.primary;

    final allFilterCategories = ['All Tasks', ...TaskCategory.allCategories];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter by Category",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          
          Text(
            "Select a category below to filter your tasks.",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 20),

          Wrap(
            spacing: 12.0, 
            runSpacing: 12.0, 
            children: allFilterCategories.map((category) {
              final isActiveFilter = category == taskProvider.selectedCategoryFilter;
              final isAllTasks = category == 'All Tasks' && taskProvider.selectedCategoryFilter == null;
              final isSelected = isActiveFilter || isAllTasks;
              
              final filterValue = category == 'All Tasks' ? null : category;
              
              final icon = _getCategoryIcon(category);

              return FilterChip(
                label: Text(category),
                avatar: Icon(icon, size: 18),
                selected: isSelected,
                onSelected: (bool selected) {
                  taskProvider.setCategoryFilter(filterValue);
                },
                
                selectedColor: primaryColor.withOpacity(0.8),
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Theme.of(context).cardColor,
                side: BorderSide(
                  color: isSelected ? primaryColor : Colors.grey.shade400,
                  width: 1.5,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'All Tasks':
        return Icons.select_all;
      case TaskCategory.personal:
        return Icons.person;
      case TaskCategory.work:
        return Icons.work;
      case TaskCategory.shopping:
        return Icons.shopping_cart;
      case TaskCategory.health:
        return Icons.fitness_center;
      case TaskCategory.finance:
        return Icons.account_balance_wallet;
      default:
        return Icons.category;
    }
  }
}