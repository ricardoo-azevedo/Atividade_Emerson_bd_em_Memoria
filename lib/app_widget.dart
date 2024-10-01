import 'package:flutter/material.dart';

import 'package:flutter_atividade_bd_memoria/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}