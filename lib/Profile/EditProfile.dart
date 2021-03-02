import 'dart:io';

import 'package:blogapp/Model/profileModel.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Profile/MainProfile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../NetworkHandler.dart';

class EditProfile extends StatefulWidget {
  //EditProfile({Key key}) : super(key: key);
  String firstName;
  String lastName;
  String location;
  String phoneNumber;
  String email;
  String dob;
  EditProfile(
      {this.firstName,
      this.lastName,
      this.location,
      this.phoneNumber,
      this.dob,
      this.email});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel();
  bool circular = false;
  PickedFile _imageFile;
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    setState(() {
      _firstName.text = widget.firstName;
      _lastName.text = widget.lastName;
      _location.text = widget.location;
      _phoneNumber.text = widget.phoneNumber;
      _email.text = widget.email;
      _dob.text = widget.dob;
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            firstNameTextField(),
            SizedBox(
              height: 20,
            ),
            lastNameTextField(),
            SizedBox(
              height: 20,
            ),
            emailTextField(),
            SizedBox(
              height: 20,
            ),
            dobField(),
            SizedBox(
              height: 20,
            ),
            locationTextField(),
            SizedBox(
              height: 20,
            ),
            phoneNumberTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                if (_globalkey.currentState.validate()) {
                  Map<String, String> data = {
                    "firstName": _firstName.text,
                    "lastName": _lastName.text,
                    "email": _email.text,
                    "DOB": _dob.text,
                    "location": _location.text,
                    "phoneNumber": _phoneNumber.text,
                  };
                  var response = await networkHandler.patch(
                      "/profile/update/${profileModel.username}", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    if (_imageFile.path != null) {
                      var imageResponse = await networkHandler.patchImage(
                          "/profile/add/image", _imageFile.path);
                      if (imageResponse.statusCode == 200) {
                        setState(() {
                          circular = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                    } else {
                      setState(() {
                        circular = false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                    }
                  }
                }
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/profile.jpeg")
              : FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget firstNameTextField() {
    return TextFormField(
      controller: _firstName,
      validator: (value) {
        if (value.isEmpty) return "firstName can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "firstName",
        helperText: "firstName can't be empty",
        hintText: "Jane",
      ),
    );
  }

  Widget lastNameTextField() {
    return TextFormField(
      controller: _lastName,
      validator: (value) {
        if (value.isEmpty) return "lastName can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "lastName",
        helperText: "lastName can't be empty",
        hintText: "Doe",
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      controller: _email,
      validator: (value) {
        if (value.isEmpty) return "email can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Email",
        helperText: "email can't be empty",
        hintText: "janedoe@gmail.com",
      ),
    );
  }

  Widget dobField() {
    return TextFormField(
      controller: _dob,
      validator: (value) {
        if (value.isEmpty) return "DOB can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Date Of Birth",
        helperText: "Provide DOB on dd/mm/yyyy",
        hintText: "01/01/2020",
      ),
    );
  }

  Widget locationTextField() {
    return TextFormField(
      controller: _location,
      validator: (value) {
        if (value.isEmpty) return "location can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "location",
        helperText: "It can't be empty",
        hintText: "location",
      ),
    );
  }

  Widget phoneNumberTextField() {
    return TextFormField(
      controller: _phoneNumber,
      validator: (value) {
        if (value.isEmpty) return "phoneNumber can't be empty";

        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        labelText: "phoneNumber",
        helperText: "Write phoneNumber yourself",
        hintText: "0712510792",
      ),
    );
  }
}
