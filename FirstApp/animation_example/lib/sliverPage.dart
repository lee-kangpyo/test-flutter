import 'package:flutter/material.dart';

class SliverPage extends StatefulWidget {
  @override
  State createState() => _SliverPage();
}

class _SliverPage extends State<SliverPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Sliver Example"),
              background: Image.asset('repo/images/'),
            ),
          )
        ],
      ),
    );
  }
}