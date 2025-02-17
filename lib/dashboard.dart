import 'package:flutter/material.dart';
import 'package:raffi_ukk2025/drawer.dart';

class Dashboard extends StatefulWidget {
  final List login;
  const Dashboard({super.key, required this.login});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myDrawer(context, widget.login[0]["Username"],
          widget.login[0]["Role"], widget.login),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 20, 78, 253),
        foregroundColor: Colors.white,
        title: Text("Dashboard"),
      ),
      body: Center(child: Text("Dashboard")),
    );
  }
}
