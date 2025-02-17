import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raffi_ukk2025/drawer.dart';
import 'package:raffi_ukk2025/pelanggan.dart/addPelanggan.dart';
import 'package:raffi_ukk2025/pelanggan.dart/deletePelanggan.dart';
import 'package:raffi_ukk2025/pelanggan.dart/editPelanggan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Pelangganindex extends StatefulWidget {
  final List login;
  const Pelangganindex({super.key, required this.login});

  @override
  State<Pelangganindex> createState() => _PelangganindexState();
}

class _PelangganindexState extends State<Pelangganindex> {
  List produk = [];
  List filterProduk = [];
  var searcCtrl = TextEditingController();
  dynamic barTitle = Text(
    "Pelanggan",
    style: GoogleFonts.raleway(),
  );
  fetchPelanggan() async {
    var result = await Supabase.instance.client
        .from('pelanggan')
        .select()
        .order("PelangganID", ascending: true);
    setState(() {
      produk = result;
      filterProduk = produk;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    // print(widget.login);
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
        title: barTitle,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  barTitle = SizedBox(
                    height: kToolbarHeight / 1.3,
                    child: TextField(
                      style: GoogleFonts.raleway(color: Colors.white),
                      controller: searcCtrl,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              alignment: Alignment.center,
                              onPressed: () {
                                setState(() {
                                  searcCtrl.clear();
                                  produk = filterProduk;
                                  barTitle = Text(
                                    "Pelanggan",
                                    style: GoogleFonts.raleway(),
                                  );
                                });
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          hintText: "Cari pelanggan",
                          hintStyle: GoogleFonts.raleway(color: Colors.white)),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            produk = filterProduk.where((item) {
                              return item["NamaPelanggan"]
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(value.toLowerCase()) ||
                                  item["Alamat"]
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(value.toLowerCase()) ||
                                  item["NomorTelepon"]
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(value.toLowerCase());
                            }).toList();
                          });
                        } else {
                          setState(() {
                            produk = filterProduk;
                          });
                        }
                      },
                    ),
                  );
                });
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: GridView.count(
          mainAxisSpacing: 10,
          childAspectRatio: 2.6,
          crossAxisCount: 1,
          children: [
            ...List.generate(produk.length, (index) {
              var produks = produk[index];
              return Card(
                  elevation: 15,
                  child: LayoutBuilder(builder: (context, constraint) {
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                produks["NamaPelanggan"],
                                style: GoogleFonts.raleway(
                                  fontSize: constraint.maxHeight / 5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: constraint.maxHeight / 8,
                              ),
                              Text("${produks["Alamat"]}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.raleway(
                                    fontSize: constraint.maxHeight / 8,
                                  )),
                              SizedBox(
                                height: constraint.maxHeight / 12,
                              ),
                              Text("${produks["NomorTelepon"]}",
                                  style: GoogleFonts.raleway(
                                      fontSize: constraint.maxHeight / 8))
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  var result = await editPelanggan(
                                      context,
                                      produks["NamaPelanggan"],
                                      produks["Alamat"],
                                      produks["NomorTelepon"],
                                      produks["PelangganID"]);
                                  if (result == true) {
                                    fetchPelanggan();
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 20, 78, 253),
                                ),
                                iconSize: constraint.maxHeight / 4,
                              ),
                              IconButton(
                                onPressed: () async {
                                  var result = await deletePelanggan(
                                      context,
                                      produks["PelangganID"],
                                      produks["NamaPelanggan"]);
                                  if (result == true) {
                                    fetchPelanggan();
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
          var result = await addPelanggan(context);
          if (result == true) {
            fetchPelanggan();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 20, 78, 253),
        foregroundColor: Colors.white,
      ),
    );
  }
}
