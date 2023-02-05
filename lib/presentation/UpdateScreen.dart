import 'package:firebase_sample/presentation/AllSceen.dart';
import 'package:firebase_sample/presentation/addScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScreenUpdate extends StatefulWidget {
  const ScreenUpdate({Key? key}) : super(key: key);

  @override
  State<ScreenUpdate> createState() => _ScreenUpdateState();
}

class _ScreenUpdateState extends State<ScreenUpdate> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(66, 50, 45, 45),
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                // controller: editedNameContoller,
                decoration: InputDecoration(
                  // alignLabelWithHint: true,

                  hintText: 'search here',

                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(10))),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 8,
            child: StreamBuilder<List<User>>(
                stream: ReadUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('something went wrong ${snapshot.error} ');
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          if (name.isEmpty) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(users[index].imageUrl),
                                radius: 23,
                              ),
                              title: Text(users[index].name),
                              subtitle: Text('${users[index].phone}'),
                              trailing: CircleAvatar(
                                child: Text('${users[index].age}'),
                              ),
                            );
                          }
                          if (users[index]
                              .name
                              .toString()
                              .toLowerCase()
                              .startsWith(name.toLowerCase())) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(users[index].imageUrl),
                                radius: 23,
                              ),
                              title: Text(users[index].name),
                              subtitle: Text('${users[index].phone}'),
                              trailing: CircleAvatar(
                                child: Text('${users[index].age}'),
                              ),
                            );
                          }
                        });
                  }
                  return Text('No Data');
                }),
          )
        ],
      ),
    );
  }
}
