import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  const TodoList(
      {super.key,
      required this.taskName,
      required this.taskCompleted,
      this.onChanged, required this.deleteFunction});

  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Checkbox(
              value: taskCompleted,
              onChanged: onChanged,
              checkColor: Colors.black,
              activeColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            Expanded(
              child: Text(taskName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.white,
                      decorationThickness: 2)),
            ),
            GestureDetector(
              onTap: () => deleteFunction(),
              child: Container(
                padding:
                    const EdgeInsets.all(8), // Adjust padding for icon size
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade200, // Background color for the icon
                  borderRadius: BorderRadius.circular(5), // Makes it a circle
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.deepPurple, // Icon color
                  size: 24, // Icon size
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
