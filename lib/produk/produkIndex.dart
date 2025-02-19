import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raffi_ukk2025/decimal.dart';
import 'package:raffi_ukk2025/drawer.dart';
import 'package:raffi_ukk2025/produk/addProduk.dart';
import 'package:raffi_ukk2025/produk/deleteProduk.dart';
import 'package:raffi_ukk2025/produk/editProduk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Produkindex extends StatefulWidget {
  final List login;
  const Produkindex({super.key, required this.login});

  @override
  State<Produkindex> createState() => _ProdukindexState();
}

class _ProdukindexState extends State<Produkindex> {
  List produk = [];
  List filterProduk = [];
  var searcCtrl = TextEditingController();
  dynamic barTitle = Text(
    "Produk",
    style: GoogleFonts.raleway(),
  );
  fetchProduk() async {
    var result = await Supabase.instance.client
        .from('produk')
        .select()
        .order("ProdukID", ascending: true);
    setState(() {
      produk = result;
      filterProduk = produk;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProduk();
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
                                    "Produk",
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
                          hintText: "Cari barang",
                          hintStyle: GoogleFonts.raleway(color: Colors.white)),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            produk = filterProduk.where((item) {
                              return item["NamaProduk"]
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(value.toLowerCase()) ||
                                  item["Harga"]
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(value.toLowerCase()) ||
                                  item["Stok"]
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
                          Container(
                            width: constraint.maxWidth / 1.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  produks["NamaProduk"],
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
                                  "Rp. ${decimal(produks["Harga"].toString())}",
                                  style: GoogleFonts.raleway(
                                      fontSize: constraint.maxHeight / 8),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: constraint.maxHeight / 12,
                                ),
                                produks["Stok"] != 0
                                    ? Text(
                                        "Sisa Stok ${produks["Stok"]}",
                                        style: GoogleFonts.raleway(
                                            fontSize: constraint.maxHeight / 8),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : Text(
                                        "Habis",
                                        style: GoogleFonts.raleway(
                                            fontSize: constraint.maxHeight / 8,
                                            color: Colors.red[600]),
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
                                  var result = await editProduk(
                                      context,
                                      produks["NamaProduk"],
                                      produks["Harga"],
                                      produks["Stok"],
                                      produks["ProdukID"]);
                                  if (result == true) {
                                    fetchProduk();
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
                                  var result = await deleteProduk(
                                      context,
                                      produks["ProdukID"],
                                      produks["NamaProduk"]);
                                  if (result == true) {
                                    fetchProduk();
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
          var result = await addProduk(context);
          if (result == true) {
            fetchProduk();
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
