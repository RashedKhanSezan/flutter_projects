import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../pages/task_details_page.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskDetailsPage(taskId: task.id),
            ),
          );
        },
        onLongPress: () {
          
          provider.deleteTask(task.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task deleted")),
          );
        },
       
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (val) {
            provider.toggleTask(task.id);
          },
          activeColor: primaryColor, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),

        
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            fontWeight: FontWeight.bold,
            color: task.isCompleted ? Colors.grey : null,
          ),
        ),

        
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
          
            Row(
              children: [
                Icon(Icons.calendar_month,
                    size: 16, color: primaryColor),
                const SizedBox(width: 4),
                Text(
                  task.dateTime.toString().split('.').first,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            
            Text(
              task.category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryColor.withOpacity(0.8),
              ),
            ),
          ],
        ),

        isThreeLine: true, 
      ),
    );
  }
}
