import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RouteTasksScreen extends StatefulWidget {
  final String routeName;

  const RouteTasksScreen({required this.routeName, super.key});

  @override
  _RouteTasksScreenState createState() => _RouteTasksScreenState();
}

class _RouteTasksScreenState extends State<RouteTasksScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Task 1', 'completed': false, 'proof': null},
    {'title': 'Task 2', 'completed': false, 'proof': null},
    {'title': 'Task 3', 'completed': false, 'proof': null},
  ];

  final ImagePicker _picker = ImagePicker();

  void _markTaskAsCompleted(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Completion'),
          content: const Text(
              'Are you sure you want to mark this task as completed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _tasks[index]['completed'] = true;
          _tasks[index]['proof'] = image.path; // Save the image path as proof
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task completed with proof uploaded!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task completion requires a photo proof.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.routeName} Route'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: ListTile(
              leading: Checkbox(
                value: task['completed'],
                onChanged: task['completed']
                    ? null
                    : (value) {
                        _markTaskAsCompleted(index);
                      },
              ),
              title: Text(
                task['title'],
                style: TextStyle(
                  decoration:
                      task['completed'] ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: task['proof'] != null
                  ? Text(
                      'Proof uploaded: ${task['proof']}',
                      style: const TextStyle(color: Colors.green),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
