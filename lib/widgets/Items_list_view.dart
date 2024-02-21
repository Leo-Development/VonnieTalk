import 'package:curved_text/curved_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/categories_provider.dart';
import 'package:voice_access/screens/category_page.dart';

class ItemsListView extends StatelessWidget {
  const ItemsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final _catData = Provider.of<CategoriesProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/BackGround2.jpg'),
                  scale: 2,
                  alignment: AlignmentDirectional(1, -1)),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          CurvedText(
            curvature: 0.005,
            text: 'Choose and add categories below',
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.orange[900],
            ),
            targetRadius: 50,
          ),
          SizedBox(
            height: 90,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 15),
            itemCount: _catData.catData.length,
            itemBuilder: (context, i) {
              final colors = [
                Colors.blue,
                Colors.amber,
                Colors.purple,
                Colors.orange,
                Colors.red,
                Colors.brown,
              ];
              return InkWell(
                child: GridTile(
                  footer: Text(
                    _catData.catData[i].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: colors[i % colors.length]),
                    //The % operator in programming is known as the modulus operator. it calculates the remainder of a division operation. in this case, i % colors. length calculates the remainder of i divided by the lenghth of the colros list.
                  ),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: _catData.catData[i].image,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoryPage(_catData.catData[i].id),
                  ));
                },
              );
            },
          )
        ],
      ),
    );
  }
}
