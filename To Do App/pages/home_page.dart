import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'add_edit_task_page.dart';
import 'categories_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;
    final primaryColor = Theme.of(context).colorScheme.primary;

    Widget tasksTab() {
      if (tasks.isEmpty) {
        final isFiltered = taskProvider.selectedCategoryFilter != null;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 20),
                Text(
                  isFiltered
                      ? "No tasks found in '${taskProvider.selectedCategoryFilter}' category."
                      : "No tasks yet.\nTap + to add one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                if (isFiltered)
                 
                  TextButton(
                    onPressed: () {
                      taskProvider.setCategoryFilter(null);
                    },
                    child: const Text("Clear Filter"),
                  )
              ],
            ),
          ),
        );
      }

    
      return ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        itemCount: tasks.length,
    
        onReorder: (oldIndex, newIndex) {
          taskProvider.reorderTasks(oldIndex, newIndex);
        },
        buildDefaultDragHandles: true,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Container(
            key: ValueKey(task.id),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: TaskCard(task: task),
          );
        },
      );
    }

    Widget bodyContent;
    switch (_currentIndex) {
      case 0:
        bodyContent = tasksTab();
        break;
      case 1:
        bodyContent = const CategoriesPage();
        break;
      case 2:
        bodyContent = const SettingsPage();
        break;
      default:
        bodyContent = tasksTab();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            if (_currentIndex == 0) ...[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My Tasks",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                        
                          Text(
                            "Viewing: ${taskProvider.selectedCategoryFilter ?? 'All Tasks'}",
                            style: TextStyle(
                                fontSize: 16,
                                color:
                                    taskProvider.selectedCategoryFilter != null
                                        ? primaryColor
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                fontWeight:
                                    taskProvider.selectedCategoryFilter != null
                                        ? FontWeight.w600
                                        : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'date_asc') {
                          taskProvider.sortByDateAscending();
                        } else if (value == 'date_desc') {
                          taskProvider.sortByDateDescending();
                        } else if (value == 'title_asc') {
                          taskProvider.sortByTitleAscending();
                        } else if (value == 'title_desc') {
                          taskProvider.sortByTitleDescending();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: 'date_asc', child: Text('Date ↑')),
                        const PopupMenuItem(
                            value: 'date_desc', child: Text('Date ↓')),
                        const PopupMenuItem(
                            value: 'title_asc', child: Text('Title A → Z')),
                        const PopupMenuItem(
                            value: 'title_desc', child: Text('Title Z → A')),
                      ],
                      icon: const Icon(Icons.sort),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(child: bodyContent),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.zero,
                      content: const AddEditTaskPage(isDialog: true),
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.label_outline), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
