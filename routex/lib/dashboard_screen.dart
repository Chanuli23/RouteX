// ignore_for_file: unused_import, use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use, unused_field, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:routex/map_screen.dart';
import 'package:routex/edit_profile_screen.dart';
import 'package:routex/settings_screen.dart';
import 'package:routex/help_support_screen.dart';
import 'package:routex/emergency_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0; // Updated to reflect the new tab structure
  late String _formattedDateTime;
  late Timer _timer;

  final List<Widget> _tabs = [
    const OngoingTab(),
    MapTab(), // Changed from CompletedTab to MapTab
    const HelpSupportTab(),
  ];

  @override
  void initState() {
    super.initState();
    _formattedDateTime = _getFormattedDateTime();
    _startDateTimeUpdater();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getFormattedDateTime() {
    final now = DateTime.now();
    final day = DateFormat('EEEE').format(now); // Day of the week
    final date = DateFormat('MMMM d, yyyy').format(now); // Date
    final time = DateFormat('hh:mm:ss a').format(now); // Time
    return '$day, $date | $time';
  }

  void _startDateTimeUpdater() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _formattedDateTime = _getFormattedDateTime();
      });
    });
  }

  void _logout(BuildContext context) async {
    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Logout',
                style: TextStyle(color: Color.fromARGB(255, 125, 196, 255)),
              ),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white, // Set full screen background to white
      body: Column(
        children: [
          // Welcome message and user icon in a blue box
          Container(
            width: double.infinity,
            color: Colors.blue, // Blue background for the box
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, $userName!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.white, // White text for contrast
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _formattedDateTime,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.white70, // Slightly faded white text
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25, // Adjust size of the user icon
                      backgroundColor: Colors.white, // Visible white background
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.person, color: Colors.blue),
                        onSelected: (value) {
                          if (value == 'Edit Profile') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen()),
                            );
                          } else if (value == 'Settings') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsScreen()),
                            );
                          } else if (value == 'Help & Support') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HelpSupportScreen()),
                            );
                          } else if (value == 'Logout') {
                            _logout(context);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 'Edit Profile',
                            child: ListTile(
                              leading: Icon(Icons.edit, color: Colors.blue),
                              title: Text('Edit Profile'),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'Settings',
                            child: ListTile(
                              leading: Icon(Icons.settings, color: Colors.blue),
                              title: Text('Settings'),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'Help & Support',
                            child: ListTile(
                              leading:
                                  Icon(Icons.help_outline, color: Colors.blue),
                              title: Text('Help & Support'),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'Logout',
                            child: ListTile(
                              leading: Icon(Icons.logout, color: Colors.blue),
                              title: Text('Logout'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Display 6 boxes
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two boxes per row for a modern layout
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio:
                      1.2, // Adjust aspect ratio for better proportions
                ),
                itemCount: 6, // Total number of route boxes
                itemBuilder: (context, index) {
                  final routes = [
                    {
                      'title': 'Jaffna',
                      'route': '/jaffna',
                      'icon': Icons.location_on
                    },
                    {
                      'title': 'Galle',
                      'route': '/galle',
                      'icon': Icons.beach_access
                    },
                    {
                      'title': 'Anuradhapura',
                      'route': '/anuradhapura',
                      'icon': Icons.temple_hindu
                    },
                    {
                      'title': 'Negombo',
                      'route': '/negombo',
                      'icon': Icons.sailing
                    },
                    {
                      'title': 'Colombo',
                      'route': '/colombo',
                      'icon': Icons.business
                    },
                    {
                      'title': 'Keells',
                      'route': '/keells',
                      'icon': Icons.shopping_cart
                    },
                  ];

                  final route = routes[index];

                  return GestureDetector(
                    onTap: () async {
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Navigation'),
                            content: Text(
                                'Do you want to navigate to ${route['title']}?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Confirm'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        Navigator.pushNamed(context, route['route'] as String);
                      }
                    },
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              route['icon'] as IconData,
                              size: 40,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              route['title'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Set bottom navbar background to white
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            // Map button index
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapScreen()),
            );
          } else if (index == 2) {
            // Emergency button index
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmergencyScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined, color: Colors.black),
            label: 'Ongoing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.black),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning, color: Colors.red),
            label: 'Emergency',
          ),
        ],
      ),
    );
  }
}

class OngoingTab extends StatefulWidget {
  const OngoingTab({super.key});

  @override
  _OngoingTabState createState() => _OngoingTabState();
}

class _OngoingTabState extends State<OngoingTab> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add({
          'title': _taskController.text.trim(),
          'completed': false,
          'completedAt': null,
        });
      });
      _taskController.clear();
    }
  }

  void _editTask(int index) {
    _taskController.text = _tasks[index]['title'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks[index]['title'] = _taskController.text.trim();
                });
                _taskController.clear();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _tasks.removeAt(index);
      });
    }
  }

  void _markTaskAsCompleted(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mark as Completed'),
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
      setState(() {
        _tasks[index]['completed'] = true;
        _tasks[index]['completedAt'] =
            DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int ongoingCount = _tasks.where((task) => !task['completed']).length;
    final int completedCount = _tasks.where((task) => task['completed']).length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Summary Table
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryItem('Ongoing', ongoingCount, Colors.orange),
                  _buildSummaryItem('Completed', completedCount, Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Add Task Section
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            labelText: 'Task Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _addTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.blue.shade100,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Task List
          Expanded(
            child: ListView.builder(
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
                        fontFamily: 'Poppins',
                        decoration: task['completed']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: task['completed']
                        ? Text(
                            'Completed at: ${task['completedAt']}',
                            style: const TextStyle(
                                fontFamily: 'Poppins', color: Colors.green),
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed:
                              task['completed'] ? null : () => _editTask(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class MapTab extends StatefulWidget {
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  late GoogleMapController _mapController;
  LatLng _currentLocation =
      const LatLng(7.8731, 80.7718); // Default to Sri Lanka center
  bool _locationLoaded = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _locationLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _locationLoaded
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 8.0, // Adjust zoom level for Sri Lanka
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: _currentLocation,
                  infoWindow: const InfoWindow(title: 'You are here'),
                ),
              },
              onMapCreated: (controller) {
                _mapController = controller;
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class HelpSupportTab extends StatelessWidget {
  const HelpSupportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        ListTile(
          leading: Icon(Icons.phone, color: Colors.blue),
          title: Text('Phone'),
          subtitle: Text('+1234567890'),
        ),
        ListTile(
          leading: Icon(Icons.email, color: Colors.blue),
          title: Text('Email'),
          subtitle: Text('support@routex.com'),
        ),
        ListTile(
          leading: Icon(Icons.help_outline, color: Colors.blue),
          title: Text('FAQ'),
        ),
      ],
    );
  }
}

class OverviewItem extends StatelessWidget {
  final String label;
  final String value;

  const OverviewItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
