import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/article_viewmodel.dart';
import 'views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArticleViewModel()..loadArticles(),
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}