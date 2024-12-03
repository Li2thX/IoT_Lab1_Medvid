import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Модель для новин
class News {
  final String title;
  final String summary;
  final String imageUrl;
  final String author;
  final String sourceName;
  final String url;

  News({
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.author,
    required this.sourceName,
    required this.url,
  });

  // Створення об'єкта News з JSON
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'No Title',
      summary: json['summary'] ?? 'No Summary',
      imageUrl: json['imageUrl'] ?? '',
      author: json['author'] ?? 'Unknown',
      sourceName: json['sourceName'] ?? 'Unknown Source',
      url: json['url'] ?? '',
    );
  }
}

// Основний екран з новинами
class CategoriesScreen extends StatelessWidget {
  // Метод для завантаження новин із API
  Future<List<News>> fetchBreakingNews() async {
  final url = Uri.parse('https://wall-street-journal.p.rapidapi.com/api/v1/checkServer');
  final response = await http.get(url, headers: {
    'X-RapidAPI-Key': '65c12c58d6mshfb19e8adfa8cb59p15e6d4jsn8924c896dca8',
    'X-RapidAPI-Host': 'wall-street-journal.p.rapidapi.com',
  });

  if (response.statusCode == 200) {
    if (response.headers['content-type']?.contains('application/json') ?? false) {
      try {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((item) => News.fromJson(item)).toList();
        } else {
          throw Exception('Unexpected JSON format');
        }
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      print('Non-JSON response detected: ${response.body}');
      throw Exception('Server returned non-JSON response');
    }
  } else {
    throw Exception('Failed to fetch news: ${response.statusCode}, Body: ${response.body}');
  }
}



  // Метод для перегляду деталей новини
  void _viewNewsDetails(BuildContext context, News news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsScreen(news: news),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breaking News', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 44, 63, 57),
      ),
      body: FutureBuilder<List<News>>(
        future: fetchBreakingNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available.'));
          } else {
            List<News> newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return ListTile(
                  title: Text(news.title),
                  subtitle: Text(news.summary),
                  leading: news.imageUrl.isNotEmpty
                      ? Image.network(news.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image_not_supported),
                  onTap: () => _viewNewsDetails(context, news),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Екран деталей новини
class NewsDetailsScreen extends StatelessWidget {
  final News news;

  NewsDetailsScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title, style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 50, 71, 66),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl.isNotEmpty)
              Image.network(news.imageUrl, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              news.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              news.summary,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'By ${news.author} | Source: ${news.sourceName}',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (news.url.isNotEmpty) {
                  launchUrl(Uri.parse(news.url));
                }
              },
              child: Text('Read Full Article'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CategoriesScreen(),
  ));
}
