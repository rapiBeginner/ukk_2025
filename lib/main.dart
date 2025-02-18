import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raffi_ukk2025/dashboard.dart';
import 'package:raffi_ukk2025/user/userIndex.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsBinding widgetBind = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetBind);
  await Supabase.initialize(
      url: "https://ewuvaeitvhljewbodryx.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3dXZhZWl0dmhsamV3Ym9kcnl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDkwMjgsImV4cCI6MjA1NDk4NTAyOH0.qoQSGpYCJzJFANMQyzD7fvS6523bRInFni1s9cPhQt0");
  runApp(const MyApp());
  // var check= await Supabase.instance.client.from('produk').select();
  // print(check);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController();
  final pwCtrl = TextEditingController();
  var hidePw = true;

  @override
  void initState() {
    super.initState();
    splashScreen();
  }
  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  void splashScreen() async {
    await Future.delayed(Duration(milliseconds: 100));
    // FlutterNativeSplash.remove();
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      var result = await Supabase.instance.client
          .from("User")
          .select()
          .eq("Username", usernameCtrl.text)
          .eq("Password", encryptPassword(pwCtrl.text));
      if (result.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text(
            "Login berhasil",
            style: GoogleFonts.raleway(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
        usernameCtrl.clear();
        pwCtrl.clear();
        // print(result);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(
                      login: result,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text(
            "Username atau password salah",
            style: GoogleFonts.raleway(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              // color: Colors.amber,
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 20, 78, 253),
            Color.fromARGB(255, 117, 131, 255),
            Color.fromARGB(255, 169, 176, 255),
            // Color.fromARGB(255, 247, 243, 243)
          ], begin: Alignment.topCenter, end: Alignment.center)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selamat datang',
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 9),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              Text(
                'isi halaman login berikut',
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 17),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              Expanded(
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                      ),
                      child: LayoutBuilder(builder: (context, constraint) {
                        return Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image.asset("asset/logo.png", height: 100, width: 100,),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                elevation: 15,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      height: constraint.maxHeight / 6,
                                      width: constraint.maxWidth / 1.5,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                width: 2,
                                                color: Color.fromARGB(
                                                    255, 117, 131, 255),
                                              ),
                                              top: BorderSide(
                                                  width: 2,
                                                  color: Color.fromARGB(
                                                      255, 117, 131, 255)),
                                              right: BorderSide(
                                                width: 2,
                                                color: Color.fromARGB(
                                                    255, 117, 131, 255),
                                              )),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                      child: Center(
                                        child: TextFormField(
                                          controller: usernameCtrl,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Username tidak boleh kosong";
                                            }

                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Username"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      height: constraint.maxHeight / 6,
                                      width: constraint.maxWidth / 1.5,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: Color.fromARGB(
                                                255, 117, 131, 255),
                                          ),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight:
                                                  Radius.circular(20))),
                                      child: Center(
                                        child: TextFormField(
                                          controller: pwCtrl,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                              border: InputBorder.none,
                                              labelText: "Password"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: constraint.maxHeight / 9,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  login();
                                  // print(encryptPassword(pwCtrl.text));
                                },
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(constraint.maxWidth / 2,
                                        constraint.maxHeight / 10),
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 117, 131, 255)),
                                child: const Text("Login"),
                              )
                            ],
                          ),
                        );
                      })))
            ],
          )),
    );
  }
}
