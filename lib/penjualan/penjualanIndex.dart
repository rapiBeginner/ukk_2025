import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:raffi_ukk2025/drawer.dart';
import 'package:raffi_ukk2025/penjualan/addPenjualan.dart';
import 'package:raffi_ukk2025/penjualan/struk.dart';
// import 'package:raffi_ukk2025/pelanggan.dart/deletePelanggan.dart';
// import 'package:raffi_ukk2025/pelanggan.dart/editPelanggan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Penjualanindex extends StatefulWidget {
  final List login;
  const Penjualanindex({super.key, required this.login});

  @override
  State<Penjualanindex> createState() => _PenjualanindexState();
}

class _PenjualanindexState extends State<Penjualanindex> {
  List produk = [];
  List pelanggan = [];
  // List filterProduk = [];
  List penjualan = [];
  var searcCtrl = TextEditingController();
  dynamic barTitle = Text(
    "Penjualan",
    style: GoogleFonts.raleway(),
  );
  fetchCustomer() async {
    var pelangganResult =
        await Supabase.instance.client.from("pelanggan").select();
    pelanggan = pelangganResult;
  }

  fetchPenjualan() async {
    var produkResult =
        await Supabase.instance.client.from("produk").select().gt("Stok", 0);
    produk = produkResult;
    var result = await Supabase.instance.client
        .from('penjualan')
        .select("*, detailpenjualan(*, produk(*)), pelanggan(*)")
        .order("PenjualanID", ascending: true);
    setState(() {
      penjualan = result;

      // filterProduk = produk;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
    fetchCustomer();
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
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         setState(() {
        //           barTitle = SizedBox(
        //             height: kToolbarHeight / 1.3,
        //             child: TextField(
        //               style: GoogleFonts.raleway(color: Colors.white),
        //               controller: searcCtrl,
        //               cursorColor: Colors.white,
        //               decoration: InputDecoration(
        //                   suffixIcon: IconButton(
        //                       alignment: Alignment.center,
        //                       onPressed: () {
        //                         setState(() {
        //                           searcCtrl.clear();
        //                           // produk=filterProduk;
        //                           barTitle = Text(
        //                             "Pelanggan",
        //                             style: GoogleFonts.raleway(),
        //                           );
        //                         });
        //                       },
        //                       icon: Icon(
        //                         Icons.close,
        //                         color: Colors.white,
        //                       )),
        //                   enabledBorder: OutlineInputBorder(
        //                       borderSide: BorderSide(
        //                         color: Colors.white,
        //                       ),
        //                       borderRadius: BorderRadius.circular(20)),
        //                   focusedBorder: OutlineInputBorder(
        //                       borderSide: BorderSide(
        //                         color: Colors.white,
        //                       ),
        //                       borderRadius: BorderRadius.circular(20)),
        //                   hintText: "Cari pelanggan",
        //                   hintStyle: GoogleFonts.raleway(color: Colors.white)),
        //               onChanged: (value) {
        //                 if (value.isNotEmpty) {
        //                   setState(() {
        //                     produk = filterProduk.where((item) {
        //                       return item["NamaPelanggan"]
        //                               .toString()
        //                               .toLowerCase()
        //                               .startsWith(value.toLowerCase()) ||
        //                           item["Alamat"]
        //                               .toString()
        //                               .toLowerCase()
        //                               .startsWith(value.toLowerCase()) ||
        //                           item["NomorTelepon"]
        //                               .toString()
        //                               .toLowerCase()
        //                               .startsWith(value.toLowerCase());
        //                     }).toList();
        //                   });
        //                 }else{
        //                   setState(() {
        //                     produk=filterProduk;
        //                   });
        //                 }
        //               },
        //             ),
        //           );
        //         });
        //       },
        //       icon: Icon(Icons.search))
        // ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: GridView.count(
          mainAxisSpacing: 10,
          childAspectRatio: 2.6,
          crossAxisCount: 1,
          children: [
            ...List.generate(penjualan.length, (index) {
              var penjualanList = penjualan[index];
              List detailList = penjualan[index]["detailpenjualan"];
              var pelangganList = penjualan[index]["pelanggan"];
              // var produkList= penjualan[index]["detailpenjualan"]["produk"];

              var tglPenjualan = DateFormat("dd MMMM yyyy")
                  .format(DateTime.parse(penjualanList["TanggalPenjualan"]));
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
                                pelangganList == null
                                    ? "Non member"
                                    : pelangganList["NamaPelanggan"],
                                style: GoogleFonts.raleway(
                                  fontSize: constraint.maxHeight / 5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: constraint.maxHeight / 8,
                              ),
                              Text(tglPenjualan,
                                  style: GoogleFonts.raleway(
                                      fontSize: constraint.maxHeight / 8)),
                              SizedBox(
                                height: constraint.maxHeight / 12,
                              ),
                              Text("${penjualanList["TotalHarga"]}",
                                  style: GoogleFonts.raleway(
                                      fontSize: constraint.maxHeight / 8))
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Detail pembelian",
                                                    style: GoogleFonts.raleway(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            20),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            25,
                                                  ),
                                                  ...List.generate(
                                                      detailList.length,
                                                      (index) {
                                                    return Row(
                                                      children: [
                                                        Text(
                                                            "${detailList[index]["produk"]["NamaProduk"]} (${detailList[index]["JumlahProduk"]})"),
                                                        Spacer(),
                                                        Text(
                                                            "Rp.${detailList[index]["Subtotal"]}")
                                                      ],
                                                    );
                                                  }),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            25,
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          20,
                                                                          78,
                                                                          253),
                                                              foregroundColor:
                                                                  Colors.white),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("Kembali"))
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.receipt_long)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Struk(
                                                login: widget.login,
                                                penjualan: penjualanList)));
                                  },
                                  icon: Icon(Icons.print)),
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
          var result = await addPenjualan(context, produk, pelanggan);
          if (result == true) {
            fetchPenjualan();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 20, 78, 253),
        foregroundColor: Colors.white,
      ),
    );
  }
}
