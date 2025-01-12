import 'package:flutter/material.dart';
import 'package:todoapp/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  List toDoList = [
    ['Learn flutter', false],
    ['Learn firebase', false]
  ];

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  // void saveNewTask() {
  //   setState(() {
  //     if (controller.text.isEmpty) return;
  //     toDoList.add([controller.text, false]);
  //     controller.clear();
  //   });
  // }

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

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

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
          // style: TextStyle(color: Colors.white),
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
