import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Products/Products.dart';
import 'package:blogapp/Model/profileModel.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Products/productList.dart';
import 'package:blogapp/Profile/EditProfile.dart';
import 'package:blogapp/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';

class MainProfile extends StatefulWidget {
  MainProfile({Key key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel();
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          },
          color: Colors.black,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => editProfile(profileModel),
            color: Colors.black,
          ),
        ],
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                head(),
                Divider(
                  thickness: 0.8,
                ),
                otherDetails("first Name", profileModel.firstName),
                otherDetails("last Name", profileModel.lastName),
                otherDetails("location", profileModel.location),
                otherDetails("phoneNumber", profileModel.phoneNumber),
                otherDetails("DOB", profileModel.DOB),
                Divider(
                  thickness: 0.8,
                ),
                SizedBox(
                  height: 20,
                ),
                /*Products(
                  url: "/blogpost/getOwnBlog",
                ),*/
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkHandler().getImage(profileModel.username),
            ),
          ),
          Text(
            "Username:${profileModel.username}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(profileModel.email)
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }

  editProfile(profileModel) {
    var firstName = profileModel.firstName;
    var lastName = profileModel.lastName;
    var location = profileModel.location;
    var phoneNumber = profileModel.phoneNumber;
    var email = profileModel.email;
    var dob = profileModel.DOB;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(
                  firstName: firstName,
                  lastName: lastName,
                  location: location,
                  phoneNumber: phoneNumber,
                  email: email,
                  dob: dob,
                )));
  }
}
