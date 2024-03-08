// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';
import 'package:wyniki/model/product_model.dart';
import 'package:wyniki/model/shop_content.dart';
import 'package:wyniki/screens/tabs_screen.dart';

import './provider/brain.dart';


import './screens/shop_screen.dart';
import './screens/best_carts_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(ShopContentAdapter());
  await Hive.openBox<ShopContent>('shops');
  await Hive.openBox<String>('favorites');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Brain(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF021D1D),
            onPrimary: Colors.white,
            secondary: Color(0xFF464949),
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: Colors.black,
            onBackground: Colors.white,
            surface: Colors.black,
            onSurface: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        home: TabsScreen(),
        routes: {
          ShopScreen.routeName: (context) => ShopScreen(),
          TabsScreen.routeName: (context) => TabsScreen(),
          BestCartsScreen.routeName: (context) => BestCartsScreen(),
        },
      ),
    );
  }
}
