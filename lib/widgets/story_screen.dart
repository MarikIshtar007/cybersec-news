import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: true,
      ),
    );
  }
}
