// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RouteTasksScreen extends StatefulWidget {
  final String routeName;

  const RouteTasksScreen({required this.routeName, super.key});

  @override
  _RouteTasksScreenState createState() => _RouteTasksScreenState();
}

class _RouteTasksScreenState extends State<RouteTasksScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Cargills Rathmalana', 'completed': false, 'proof': null},
    {'title': 'Laughs Galkissa', 'completed': false, 'proof': null},
    {'title': 'Keells Dehiwala', 'completed': false, 'proof': null},
    {'title': 'Glomark Wellawaththa', 'completed': false, 'proof': null},
    {'title': 'Arpico Colpetty', 'completed': false, 'proof': null},
    {'title': 'Spar Bambalapitiya', 'completed': false, 'proof': null},
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
          _tasks[index]['completedAt'] = DateFormat('yyyy-MM-dd hh:mm:ss a')
              .format(DateTime.now()); // Save completion time
          _tasks
              .add(_tasks.removeAt(index)); // Move completed task to the bottom
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

  void _showTaskDetails(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              task['title'],
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(color: Colors.blue, thickness: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.category, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Product Type: ${task['productType'] ?? 'N/A'}',
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.production_quantity_limits,
                      color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Quantity: ${task['quantity'] ?? 'N/A'}',
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Assigned By: ${task['assignedBy'] ?? 'N/A'}',
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                ],
              ),
              if (task['completed']) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      'Completed At: ${task['completedAt'] ?? 'N/A'}',
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.routeName} Route',
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return GestureDetector(
              onTap: () => _markTaskAsCompleted(index),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
                shadowColor: Colors.blue.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.blue.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      task['completed']
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task['completed'] ? Colors.green : Colors.grey,
                      size: 30,
                    ),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        decoration: task['completed']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task['proof'] != null)
                          const Text(
                            'Proof uploaded',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.green,
                            ),
                          ),
                        if (task['completedAt'] != null)
                          Text(
                            'Completed At: ${task['completedAt']}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.green,
                            ),
                          ),
                        if (task['proof'] == null)
                          const Text(
                            'Pending',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info, color: Colors.blue),
                      onPressed: () => _showTaskDetails(task),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
