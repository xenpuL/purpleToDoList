import 'package:flutter/material.dart';
import 'package:todoapp/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

  // _HomePageState is the state of the HomePage widget.
  // It contains the todo list data and the text editing controller.
class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  List toDoList = [
    ['Learn flutter', false],
    ['Learn firebase', false]
  ];

  /// Called when the checkbox at the given index is changed.
  ///
  /// Updates the state of the task at the given index to the opposite of its
  /// current state.
  ///
  /// The given index must be a valid index into the [toDoList].
  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  /// Adds a new task to the to-do list and clears the text field.
  ///
  /// If the given [task] is not null, it is used as the new task.
  /// Otherwise, the text in the text field is used as the new task.
  ///
  /// If the new task is empty, nothing is added to the to-do list.
  ///
  /// Shows a SnackBar when a new task is added.
  void saveNewTask({String? task}) {
    String newTask = task ?? controller.text.trim();
    if (newTask.isEmpty) return;

    setState(() {
      toDoList.add([newTask, false]);
      controller.clear();
    });

    // Show a SnackBar when a new task is added
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task added successfully!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  /// Deletes the task at the given [index] from the to-do list.
  ///
  /// The given [index] must be a valid index into the [toDoList].
  ///
  /// Shows a SnackBar when a task is deleted.
  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  /// Shows a dialog asking the user to confirm deletion of the task at the
  /// given [index] from the to-do list.
  ///
  /// The given [index] must be a valid index into the [toDoList].
  ///
  /// If the user confirms deletion, the task is removed from the to-do list.
  ///
  /// Shows a SnackBar when a task is deleted.
  void confirmDeleteTask(int index) {
    String deletedTask =
        toDoList[index][0]; // Capture the task name before deletion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  toDoList.removeAt(index); // Delete the task
                });
                Navigator.of(context).pop(); // Close the dialog

                // Show a SnackBar when a task is deleted
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task "$deletedTask" deleted successfully!'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Text(
          'Simple To-Do',
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: toDoList.isEmpty
          ? const Center(
              child: Text(
                'No tasks available. Add a new task!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (BuildContext context, index) {
                return TodoList(
                  taskName: toDoList[index][0],
                  taskCompleted: toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(index),
                  deleteFunction: () => confirmDeleteTask(index),
                );
              }),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.deepPurple.shade200,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Add new task',
                ),
                onSubmitted: (value) => saveNewTask(task: value),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
            onPressed: () => saveNewTask(),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
