import 'package:flutter/material.dart';
import 'mypage.dart';
import 'tire_data_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TireDataModel>(
          create: (_) => TireDataModel(),
        ),
        Provider<ValueNotifier<Map<String, dynamic>>>(
          create: (_) => ValueNotifier<Map<String, dynamic>>({}),
        ),
      ],
      child: MaterialApp(
        title: 'My App',
        home: MyHomePage(),
      ),
    );
  }
}