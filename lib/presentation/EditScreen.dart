import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/presentation/addScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.snapshot, required this.index});

  final AsyncSnapshot<List<User>> snapshot;
  final int index;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    final users = widget.snapshot.data!;
    final editedNameContoller =
        TextEditingController(text: users[widget.index].name);
    final editedAgeController =
        TextEditingController(text: users[widget.index].age.toString());
    final editedPhoneController =
        TextEditingController(text: users[widget.index].phone.toString());
    return Scaffold(
      // backgroundColor: Color.fromARGB(66, 61, 44, 44),
      appBar: AppBar(
        centerTitle: true,
        title: Text('edit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: editedNameContoller,
                decoration: InputDecoration(
                  // alignLabelWithHint: true,
                  label: Text(
                    editedNameContoller.text,
                  ),
                  hintText: editedNameContoller.text,
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
                controller: editedAgeController,
                decoration: InputDecoration(
                  labelText: editedAgeController.text,
                  hintText: editedAgeController.text,
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
                controller: editedPhoneController,
                decoration: InputDecoration(
                  labelText: editedPhoneController.text,
                  hintText: editedPhoneController.text,
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
                  final docUser = FirebaseFirestore.instance
                      .collection('user')
                      .doc(users[widget.index].id);
                  docUser.update({
                    'name': editedNameContoller.text,
                    'age': int.parse(editedAgeController.text),
                    'phone': int.parse(editedPhoneController.text),
                  });

                  Navigator.pop(context);
                },
                label: Icon(Icons.update),
              ),
            )
          ],
        ),
      ),
    );
  }
}
