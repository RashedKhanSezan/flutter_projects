import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'add_edit_task_page.dart';

class TaskDetailsPage extends StatelessWidget {
  final String taskId;

  const TaskDetailsPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final task = provider.getTaskById(taskId);
    final primaryColor = Theme.of(context).colorScheme.primary; // Teal color

    if (task == null) {
      return const Scaffold(
        body: Center(child: Text("Task not found.")),
      );
    }

    // Adjust background color based on theme
    final cardColor = Theme.of(context).cardColor;
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: const Text("Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text(
              "Task Details",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // MAIN CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      color: task.isCompleted ? Colors.grey : null,
                    ),
                  ),

                  const SizedBox(height: 15),
                  
                  // Display Category
                  Row(
                    children: [
                      Icon(Icons.label, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        task.category,
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Description
                  Text(
                    task.description.isEmpty
                        ? "No description"
                        : task.description,
                    style: TextStyle(
                      fontSize: 16,
                      // Adjusted color for dark mode readability
                      color: Theme.of(context).textTheme.bodyLarge?.color, 
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Date & Time
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: primaryColor), // Updated icon color
                      const SizedBox(width: 8),
                      Text(
                        task.dateTime.toString().split('.').first,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // BUTTONS
            Row(
              children: [
                // DELETE
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      provider.deleteTask(task.id);
                      Navigator.pop(context);
                    },
                    child: const Text("Delete"),
                  ),
                ),
                const SizedBox(width: 12),

                // EDIT
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Updated button color (Teal)
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Pop the current details page before pushing the edit page
                      Navigator.pop(context); 
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding: EdgeInsets.zero,
                            content: AddEditTaskPage(task: task, isDialog: true),
                          );
                        },
                      );
                    },
                    child: const Text("Edit"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}