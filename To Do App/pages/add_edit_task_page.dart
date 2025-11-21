import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/task_category.dart'; 

class AddEditTaskPage extends StatefulWidget {
  final bool isDialog;
  final Task? task;

  const AddEditTaskPage({
    super.key,
    this.task,
    this.isDialog = false,
  });

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDateTime;
  String selectedCategory = TaskCategory.personal; 

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedDateTime = widget.task!.dateTime;
      selectedCategory = widget.task!.category; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final inputFillColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      width: 350,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.task == null ? "Add New Task" : "Edit Task",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Task Title",
              filled: true,
              fillColor: inputFillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Description",
              filled: true,
              fillColor: inputFillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),

          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              filled: true,
              fillColor: inputFillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelText: "Category",
            ),
            items: TaskCategory.allCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 15),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor, 
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2050),
                initialDate: selectedDateTime ?? DateTime.now(),
              );

              if (date == null) return;

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
              );

              if (time == null) return;

              setState(() {
                selectedDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              });
            },
            child: Text(
              selectedDateTime == null
                  ? "Pick Date & Time"
                  : "Selected: ${selectedDateTime.toString().split('.').first}",
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, 
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isEmpty || selectedDateTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Title & Date/Time are required")),
                  );
                  return;
                }

                if (widget.task == null) {
                  provider.addTask(title, description, selectedDateTime!, selectedCategory);
                } else {
                  provider.updateTask(
                    widget.task!.id,
                    title,
                    description,
                    selectedDateTime!,
                    selectedCategory,
                  );
                }

                Navigator.pop(context);
              },
              child: Text(widget.task == null ? "Add Task" : "Save Changes"),
            ),
          ),
        ],
      ),
    );
  }
}