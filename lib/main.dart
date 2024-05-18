import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_github_linked/key.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Starred Repos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyGitHubRepositories(),
    );
  }
}

class MyGitHubRepositories extends StatefulWidget {
  @override
  _MyGitHubRepositoriesState createState() => _MyGitHubRepositoriesState();
}

class _MyGitHubRepositoriesState extends State<MyGitHubRepositories> {
  List<dynamic> repositories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRepositories();
  }

  Future<void> fetchRepositories() async {
    final String token = apiKey;
    final response = await http.get(
      Uri.https('api.github.com', '/user/starred'),
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        repositories = json.decode(response.body);
        isLoading = false;
      });
    } else {
      // Handle error
      print('Failed to load repositories');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Starred Repositories'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(repositories[index]['name']),
                  subtitle: Text(repositories[index]['description'] ?? ''),
                  onTap: () {
                    // Handle tap on repository
                  },
                );
              },
            ),
    );
  }
}
