import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_sample/presentation/AllSceen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
 
class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  
 final namecontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(66, 50, 45, 45),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                onPressed: () {
                  final name = namecontroller.text;
                  final age = int.parse(agecontroller.text);

                  final phone = int.parse(phonecontroller.text);
                  final user = User(name, age, phone, '');

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
  String id;
  final String name;
  final int age;
  final int phone;
  User(this.name, this.age, this.phone, this.id);

  Map<String, dynamic> tojson() => {
        'id': id,
        'name': name,
        'age': age,
        'phone': phone,
      };
  static User fromJson(Map<String, dynamic> json) => User(
        json['name'],
        json['age'],
        json['phone'],
        json['id'],
      );
}
