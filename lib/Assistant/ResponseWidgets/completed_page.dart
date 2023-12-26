import 'package:flutter/material.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  CompletedPageState createState() => CompletedPageState();
}

class CompletedPageState extends State<CompletedPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Completed'),
          Text('오류거나 끝난 페이지')
        ],
      ),
    );
  }
}
