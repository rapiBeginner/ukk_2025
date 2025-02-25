import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raffi_ukk2025/drawer.dart';
import 'package:raffi_ukk2025/user/addUser.dart';
import 'package:raffi_ukk2025/user/deleteUser.dart';
import 'package:raffi_ukk2025/user/editUser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Userindex extends StatefulWidget {
  final List login;
  const Userindex({super.key, required this.login});

  @override
  State<Userindex> createState() => _UserindexState();
}

class _UserindexState extends State<Userindex> {
  List user = [];
  fetchUser() async {
    var result = await Supabase.instance.client
        .from('User')
        .select()
        .order("UserID", ascending: true);
    setState(() {
      user = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myDrawer(context, widget.login[0]["Username"],
          widget.login[0]["Role"], widget.login),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 20, 78, 253),
        foregroundColor: Colors.white,
        title: Text(
          "Pengguna",
          style: GoogleFonts.raleway(),
        ),
      ),
      body: user.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: GridView.count(
                mainAxisSpacing: 10,
                childAspectRatio: 2.6,
                crossAxisCount: 1,
                children: [
                  ...List.generate(user.length, (index) {
                    var users = user[index];
                    return Card(
                        elevation: 15,
                        child: LayoutBuilder(builder: (context, constraint) {
                          return Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Container(
                                  width: constraint.maxWidth / 1.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        users["Username"],
                                        style: GoogleFonts.raleway(
                                          fontSize: constraint.maxHeight / 5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: constraint.maxHeight / 8,
                                      ),
                                      Text(
                                        users["Role"],
                                        style: GoogleFonts.raleway(
                                            fontSize: constraint.maxHeight / 8),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        var result = await editUser(
                                            context,
                                            users["Username"],
                                            users["Password"],
                                            users["UserID"]);
                                        if (result == true) {
                                          fetchUser();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 20, 78, 253),
                                      ),
                                      iconSize: constraint.maxHeight / 4,
                                    ),
                                    // SizedBox(
                                    //   height: constraint.maxHeight / 10,
                                    // ),
                                    IconButton(
                                      onPressed: () async {
                                        var result = await deleteUser(context,
                                            users["UserID"], users["Username"]);
                                        if (result == true) {
                                          fetchUser();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(255, 253, 20, 55),
                                      ),
                                      iconSize: constraint.maxHeight / 4,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }));
                  })
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await addUser(context);
          if (result == true) {
            fetchUser();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 20, 78, 253),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
