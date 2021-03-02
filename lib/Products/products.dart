import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Products/Products.dart';
import 'package:blogapp/Products/productList.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: SingleChildScrollView(
        child: Products(
          url: "/product/getproducts",
        ),
      ),
    );
  }
}
