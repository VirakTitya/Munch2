import 'package:flutter/material.dart';
import 'package:munch2/presentation/screens/main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(), 
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> e2db759995fa554ddc40347d50156bce7d4742df
