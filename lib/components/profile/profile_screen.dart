import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Color.fromARGB(255, 30, 66, 229)),
      ),
      color: Colors.white, // This sets the popup menu background to white
      onSelected: (value) {
        if (value == 'profile') {
          // Navigate to view profile
        } else if (value == 'password') {
          // Navigate to change password
        } else if (value == 'logout') {
          // Handle logout
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'profile',
          child: Text('View Profile'),
        ),
        const PopupMenuItem<String>(
          value: 'password',
          child: Text('Change Password'),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Log Out'),
        ),
      ],
    );
  }
}