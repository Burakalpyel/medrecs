import 'package:flutter/material.dart';

class detailPage extends StatelessWidget {
  final int index;

  detailPage(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details Page")),
      body: Center(
        child: Text("The details page #$index"),
      ),
    );
  }
}
