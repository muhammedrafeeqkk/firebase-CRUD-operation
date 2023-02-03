import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScreenUpdate extends StatelessWidget {
  const ScreenUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(66, 50, 45, 45),
      appBar: AppBar(
        title: Text('Updation'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.delete),
                label: Text('Delete')),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.update),
                label: Text('Update'))
          ],
        ),
      ),
    );
  }
}
