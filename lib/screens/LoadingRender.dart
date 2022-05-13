import 'package:flutter/material.dart';

class LoadingRender extends StatelessWidget {
  const LoadingRender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}
