import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Новини',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showLogoutDialog(context); // Викликаємо вікно підтвердження виходу
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNewsBanner(),
              SizedBox(height: 20),
              _buildMainButtons(),
              SizedBox(height: 20),
              _buildNewsCategoriesSection(context),
              SizedBox(height: 20),
              _buildAboutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsBanner() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage('assets/news_banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          'Ласкаво просимо до Новин!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black,
                offset: Offset(3, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(
          label: 'Технології',
          icon: Icons.computer,
          onPressed: () {
            // Перехід до розділу новин про технології
          },
        ),
        _buildButton(
          label: 'Спорт',
          icon: Icons.sports_soccer,
          onPressed: () {
            // Перехід до розділу спортивних новин
          },
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade800,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildNewsCategoriesSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Категорії Новин',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildNewsTile(context, 'Світові новини', Icons.public),
          _buildNewsTile(context, 'Бізнес', Icons.business),
          _buildNewsTile(context, 'Здоров\'я', Icons.health_and_safety),
        ],
      ),
    );
  }

  Widget _buildNewsTile(BuildContext context, String categoryName, IconData icon) {
    return ListTile(
      title: Text(categoryName),
      leading: Icon(icon),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        // Перехід до відповідної категорії новин
      },
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Про нас',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Ми надаємо найактуальніші новини зі світу технологій, спорту, бізнесу та багато іншого. Будьте в курсі подій!',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Вийти з акаунту?'),
        content: Text('Ви дійсно хочете вийти з акаунту?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              // Вихід з акаунту
              _logout(context);
            },
            child: Text('Вийти'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Очищення збережених даних
    Navigator.pushReplacementNamed(context, '/login'); // Перехід на екран входу
  }
}
