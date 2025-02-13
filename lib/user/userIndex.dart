import 'package:flutter/material.dart';

class Userindex extends StatefulWidget {
  const Userindex({super.key});

  @override
  State<Userindex> createState() => _UserindexState();
}

class _UserindexState extends State<Userindex> {
  fetchUser(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   ,
      // ),
      body: Padding(padding: EdgeInsets.all(10), child: GridView.count(crossAxisCount: 2, children: [
        // List.generate(length, generator)
      ],),),
    );
  }
}