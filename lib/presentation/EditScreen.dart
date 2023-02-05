import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/presentation/addScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.snapshot, required this.index});

  final AsyncSnapshot<List<User>> snapshot;
  final int index;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  File? _image;
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

    updatePick() async {
      String filename = basename(_image!.path);
      final firebaseStorageref = FirebaseStorage.instance
          .refFromURL(widget.snapshot.data![widget.index].imageUrl);
      final updateTask = firebaseStorageref.putFile(_image!);
      final taskSnapshot = await updateTask.whenComplete(() async {});
      final firestoreimageUrl = await firebaseStorageref.getDownloadURL();

      // log('first $firestoreimageUrl');

      return firestoreimageUrl;
    }

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
              padding: EdgeInsets.all(18.0),
              child: Stack(children: [
                CircleAvatar(
                  backgroundImage: (_image == null)
                      ? NetworkImage(users[widget.index].imageUrl)
                      : FileImage(_image!) as ImageProvider,
                  //
                  radius: 70,
                ),
                IconButton(
                    onPressed: () async {
                      getImage(ImageSource.gallery);

                      final result = await updatePick();

                      // final DocUser = FirebaseStorage.instance
                      //     .refFromURL(users[widget.index].imageUrl);
                      //     final newpath =  getImage(ImageSource.gallery);
                      //     DocUser.updateMetadata();
                    },
                    icon: Icon(Icons.add_a_photo))
              ]),
            ),
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
                onPressed: () async {
                  final url = await updatePick();
                  final docUser = FirebaseFirestore.instance
                      .collection('user')
                      .doc(users[widget.index].id);
                  docUser.update({
                    'imageUrl': url,
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
