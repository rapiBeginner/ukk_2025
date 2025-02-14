import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

editUser(BuildContext context, String username, String pw, int Id) {
  final formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController( text: username);
  final pwCtrl = TextEditingController(text: pw);
  bool hidePw = true;

  insertUser() async {
    if (formKey.currentState!.validate()) {
       var checkUser = await Supabase.instance.client
          .from("User")
          .select()
          .eq("Username", usernameCtrl.text);
      if (checkUser.isNotEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           duration: Duration(milliseconds: 1000),
          content: Text(
            "Username telah digunakan",
            style: GoogleFonts.raleway(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
      else{
        var result = await Supabase.instance.client.from("User").update(
          {"Username": usernameCtrl.text, "Password": pwCtrl.text}
        ).eq("UserID", Id);
        if (result == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
             duration: Duration(milliseconds: 1000),
            content: Text(
              "Edit pengguna berhasil",
              style: GoogleFonts.raleway(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop(true);
        }
      }
    }
  }

  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Container(
                height: MediaQuery.of(context).size.height / 2.2,
                width: MediaQuery.of(context).size.width / 1.3,
                child: LayoutBuilder(builder: (context, constraint) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Edit Pengguna",
                              style: GoogleFonts.raleway(
                                  fontSize: constraint.maxWidth / 15),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 10,
                            ),
                            TextFormField(
                              controller: usernameCtrl,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Username tidak boleh kosong";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Username",
                                  labelStyle: GoogleFonts.raleway(),
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 20,
                            ),
                            TextFormField(
                              controller: pwCtrl,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password tidak boleh kosong";
                                }
                                return null;
                              },
                              obscureText: hidePw,
                              decoration: InputDecoration(
                                  suffix: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          hidePw = !hidePw;
                                        });
                                      },
                                      icon: Icon(Icons.visibility)),
                                  labelText: "Password",
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 15,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                insertUser();
                              },
                              child: Text(
                                "Simpan",
                                style: GoogleFonts.raleway(),
                              ),
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                    constraint.maxWidth / 2,
                                    constraint.maxHeight / 10,
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 20, 78, 253),
                                  foregroundColor: Colors.white),
                            )
                          ],
                        )),
                  );
                })),
          );
        });
      });
}
