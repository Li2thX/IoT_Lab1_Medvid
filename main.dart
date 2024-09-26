import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Increment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IncrementScreen(),
    );
  }
}

class IncrementScreen extends StatefulWidget {
  @override
  _IncrementScreenState createState() => _IncrementScreenState();
}

class _IncrementScreenState extends State<IncrementScreen> with SingleTickerProviderStateMixin {
  int _counter = 0;
  final TextEditingController _textController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      String inputText = _textController.text;
      if (inputText == "Avada Kedavra") {
        _controller.forward().then((value) {
          setState(() {
            _counter = 0;
            _backgroundColor = Colors.redAccent; // Зміна фону на червоний
          });
          _controller.reverse(); // Повернення до нормального стану
        });
      } else {
        int? number = int.tryParse(inputText);
        if (number != null) {
          _counter += number;
          _backgroundColor = Colors.white; // Відновлення фону
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Введіть число або "Avada Kedavra" для скидання!'),
            ),
          );
        }
      }
      _textController.clear(); // Очищення текстового поля
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Інтерактивний лічильник'),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        color: _backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Лічильник:',
              style: TextStyle(fontSize: 24),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium, // headline4 замінено на headlineMedium
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введіть число або "Avada Kedavra"',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Застосувати'),
            ),
          ],
        ),
      ),
    );
  }
}
