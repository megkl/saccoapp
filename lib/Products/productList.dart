import 'package:blogapp/CustomWidget/BlogCard.dart';
import 'package:blogapp/Products/productDetail.dart';
import 'package:blogapp/Model/SuperModel.dart';
import 'package:blogapp/Model/addBlogModels.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Products/products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products extends StatefulWidget {
  Products({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel();
  List<AddBlogModel> data = [];
  AddBlogModel addBlogModel = AddBlogModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url);
    superModel = SuperModel.fromJson(response);
    setState(() {
      data = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? Column(
            children: data
                .map((item) => Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => ProductDetails(
                                          addBlogModel: item,
                                          networkHandler: networkHandler,
                                        )));
                          },
                          child: Column(
                            children: [
                              BlogCard(
                                addBlogModel: item,
                                networkHandler: networkHandler,
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => showDeleteAlert(context, item),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                      ],
                    ))
                .toList(),
          )
        : Center(
            child: Text("We don't have any Products Yet"),
          );
  }

  showDeleteAlert(BuildContext context, item) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(color: Colors.purple),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Yes", style: TextStyle(color: Colors.purple)),
      onPressed: () async {
        Navigator.pop(context);
        var response =
            await networkHandler.delete("/product/delete/${addBlogModel.id}");
        print(response.body);
        if (response.statusCode == 200) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProductsScreen()));
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Would you like to delete this product?"),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
