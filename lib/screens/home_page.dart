import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/categories_provider.dart';
import 'package:voice_access/providers/items.dart';
import 'package:voice_access/screens/add_category.dart';
import 'package:voice_access/widgets/Items_list_view.dart';
//import 'package:voice_access/widgets/categories_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // print('blur value ${blurValueNot.blurValue}');
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.yellowAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('VonnieTalk'),
          backgroundColor: Color.fromARGB(255, 125, 142, 235),
          actions: [
            TextButton.icon(
                label: const Text('Add Category'),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddCategory.routeName);
                  Provider.of<Items>(context, listen: false).counting();
                  //print('second blur valu ${blurValueNot.blurValue}');
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(
          //controller: scrollcontrol,
          child: FutureBuilder(
            future: Provider.of<CategoriesProvider>(context, listen: false)
                .fetchAndSet(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.error != null) {
                const Center(
                  child: Text('An error occurredd'),
                );
              }
              return ItemsListView();
            },
          ),
        ),
      ),
    );
  }
}
