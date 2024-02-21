import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/audio_data.dart';
import 'package:voice_access/providers/categories_provider.dart';
import 'package:voice_access/providers/items.dart';
import 'package:voice_access/screens/add_data.dart';
import 'package:voice_access/screens/language.dart';
import 'package:voice_access/widgets/item_list.dart';

class CategoryPage extends StatelessWidget {
  static const routeName = '/CategoryPage';
  final String categoryId;
  CategoryPage(this.categoryId);
  @override
  Widget build(BuildContext context) {
    final _category = Provider.of<CategoriesProvider>(context, listen: false)
        .findById(categoryId);

    return Scaffold(
        appBar: AppBar(
          title: Text(_category.title),
          actions: [
            TextButton.icon(
                label: const Text('Add Item'),
                onPressed: () {
                  Provider.of<AudioData>(context, listen: false).removeAudio();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddData(categoryId),
                  ));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: Stack(children: [
          FutureBuilder(
            future:
                Provider.of<Items>(context, listen: false).fecthAndSetPlace(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.error != null) {
                return Text('An error occured');
              } else {
                final _items = Provider.of<Items>(context)
                    .fetchItemsByCategory(categoryId);
                return _items.isEmpty
                    ? const Center(
                        child: Image(image: AssetImage('assets/sad.jfif')),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemCount: _items.length,
                        itemBuilder: (context, i) {
                          print('Building itemLiist:${_items[i].title}');
                          return ItemList(_items[i]);
                        },
                      );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Language.routeName);
                  },
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Language.routeName);
                      },
                      icon: Icon(Icons.settings)),
                  style: ButtonStyle(alignment: Alignment.bottomLeft)),
            ),
          )
        ]));
  }
}
