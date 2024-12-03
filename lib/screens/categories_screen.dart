import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../app_colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // Категорії новин
  List<String> get news => [
    'Technology',
    'World News',
    'Business',
    'Sports',
    'Health',
  ];

  // Іконки для кожної категорії
  List<IconData> get icons => [
    Icons.computer, // Technology
    Icons.public, // World News
    Icons.business, // Business
    Icons.sports, // Sports
    Icons.health_and_safety, // Health
  ];

  // Функція для показу діалогу виходу
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  // Слухач для перевірки підключення до мережі
  void _listenToConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are offline. Some features may be limited.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are back online.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenToConnectivity(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Categories', style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.whiteColor),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(news[index]),
            leading: Icon(icons[index]), // Відповідна іконка для категорії
            onTap: () {
              // Тут можна додати навігацію до деталей новин
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
        tooltip: 'Go to Profile',
        child: const Icon(Icons.account_circle),
      ),
    );
  }
}
