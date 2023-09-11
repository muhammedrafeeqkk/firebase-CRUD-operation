import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/presentation/EditScreen.dart';
import 'package:firebase_sample/presentation/addScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UseerScreen extends StatelessWidget {
  const UseerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(66, 70, 48, 48),
        appBar: AppBar(
          title: Text('User'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<User>>(
          stream: ReadUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('something went wrong ${snapshot.error} ');
            } else if (snapshot.hasData) {
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(users[index].imageUrl),
                    ),
                    title: Text(users[index].name),
                    subtitle: Text('${users[index].phone}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            // onPressed: () {
                            //   final docUser = FirebaseFirestore.instance
                            //       .collection('user')
                            //       .doc(users[index].id);

                            //   docUser.update({'name': 'muhammed'});
                            // },
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditScreen(
                                    snapshot: snapshot,
                                    index: index,
                                  ),
                                )),
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              final docUser = FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(users[index].id);
                              docUser.delete();
                              final imagDoc = FirebaseStorage.instance
                                  .refFromURL(users[index].imageUrl);

                              imagDoc.delete();
                            },
                            icon: Icon(Icons.delete)),
                        CircleAvatar(
                          child: Text('${users[index].age}',
                              style: TextStyle(
                                color: Colors.black,
                              )),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

//   Widget buildUser(User user) => ListTile(
//         leading: CircleAvatar(
//           child: Text('${user.age}'),
//         ),
//         title: Text(user.name),
//         subtitle: Text('${user.phone}'),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
//             IconButton(onPressed: () {}, icon: Icon(Icons.delete))
//           ],
//         ),
//       );
}

Stream<List<User>> ReadUser() =>
    FirebaseFirestore.instance.collection('user').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
