import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_sample/presentation/AllSceen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  File? _image;

  final namecontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future getImage(ImageSource source) async {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      setState(() {
        _image = img;
      });
    }

    uploadPick() async {
      String filename = basename(_image!.path);
      final firebaseStorageref = FirebaseStorage.instance.ref().child(filename);
      final uploadTask = firebaseStorageref.putFile(_image!);
      final taskSnapshot = await uploadTask.whenComplete(() async {});
      final firestoreimageUrl = await firebaseStorageref.getDownloadURL();

      // log('first $firestoreimageUrl');

      return firestoreimageUrl;
    }

    // print(imageurl.toString());

    return Scaffold(
      backgroundColor: Color.fromARGB(66, 50, 45, 45),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(children: [
                  _image == null
                      ? CircleAvatar(
                          backgroundImage: const AssetImage('asset/person.png'),
                          radius: 70,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(_image!),
                          radius: 70,
                        ),
                  IconButton(
                      onPressed: () async {
                        await getImage(ImageSource.gallery);

                        await uploadPick();
                        final resuuu = await uploadPick();
                        print(resuuu);
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 30,
                      ))
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    hintText: 'name',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(10))),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: agecontroller,
                  decoration: InputDecoration(
                    hintText: 'age',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(10))),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phonecontroller,
                  decoration: const InputDecoration(
                    hintText: 'phone number',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(10))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    final name = namecontroller.text;
                    final age = int.parse(agecontroller.text);
                    final imageUrl = await uploadPick();

                    final phone = int.parse(phonecontroller.text);
                    final user = User(name, age, phone, '', imageUrl);

                    createUser(user: user);

                    agecontroller.clear();
                    namecontroller.clear();
                    phonecontroller.clear();
                  },
                  label: Icon(Icons.person),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future createUser({required User user}) async {
    //refference to documents
    final DocUser = FirebaseFirestore.instance.collection('user').doc();
    user.id = DocUser.id;
    // final user = User( name: name, age: age, birthDay: date);
    final json = user.tojson();

//Create documents and write data to Firebase
    await DocUser.set(json);
  }
}

class User {
  String imageUrl;
  String id;
  final String name;
  final int age;
  final int phone;
  User(this.name, this.age, this.phone, this.id, this.imageUrl);

  Map<String, dynamic> tojson() => {
        'id': id,
        'name': name,
        'age': age,
        'phone': phone,
        'imageUrl': imageUrl
      };
  static User fromJson(Map<String, dynamic> json) => User(
      json['name'], json['age'], json['phone'], json['id'], json['imageUrl']);
}
