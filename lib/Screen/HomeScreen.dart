import 'package:blogapp/Model/imagesModel.dart';
import 'package:blogapp/Model/menuModel.dart';
import 'package:blogapp/Model/routesModel.dart';
import 'package:blogapp/Products/productList.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      body: getBody(),
    );
  }

  Widget getBody() {
    return GridView.builder(
        itemCount: images.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => pageRoutes[index]));
            },
            child: Card(
              margin: EdgeInsets.all(20),
              child: ListTile(
                title: Image.asset(
                  images[index],
                  height: 80,
                ),
                subtitle: Text(
                  menus[index],
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
          //return CardItem(menus[index]);
          //return Image.asset(images[index]);
        });
  }
}
