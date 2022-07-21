import 'package:flutter/material.dart';

import 'home/home_page_content.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection App'),
        centerTitle: true,
      ),
      body: const HomePageContent(),
    );
  }
}
