import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/audio_data.dart';
import 'package:voice_access/providers/blurValueNotifier.dart';
import 'package:voice_access/providers/categories_provider.dart';
import 'package:voice_access/providers/items.dart';
import 'package:voice_access/providers/languageNot.dart';
import 'package:voice_access/screens/add_category.dart';
import 'package:voice_access/screens/language.dart';
import 'package:voice_access/widgets/splashScreen.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Items(),
        ),
        ChangeNotifierProvider(
          create: (context) => AudioData(),
        ),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => LanguageNot()),
        ChangeNotifierProvider(
          create: (context) => BlurValueNotifier(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          // AddData.routeName: (context) => AddData(),
          '/': (context) => SplashScreen(),
          AddCategory.routeName: (context) => const AddCategory(),
          Language.routeName: (context) => const Language(),
          // CategoryPage.routeName:(context) =>const CategoryPage(),
        },
      ),
    );
  }
}
