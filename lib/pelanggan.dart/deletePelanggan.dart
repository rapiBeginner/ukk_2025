import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

deletePelanggan(BuildContext context, int id, String namaPelanggan) async {
  var checkSales = await Supabase.instance.client
      .from("penjualan")
      .select()
      .eq("PelangganID", id);
  return showDialog(
      context: context,
      builder: (context) {
        if (checkSales.isEmpty) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 1.3,
              child: LayoutBuilder(builder: (context, constraint) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Pelanggan bernama $namaPelanggan akan dihapus",
                      style: GoogleFonts.raleway(
                          fontSize: constraint.maxWidth / 15),
                    ),
                    SizedBox(
                      height: constraint.maxHeight / 8,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var result = await Supabase.instance.client
                            .from("pelanggan")
                            .delete()
                            .eq("PelangganID", id);
                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 1000),
                            content: Text(
                              "Hapus pelanggan berhasil",
                              style: GoogleFonts.raleway(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ));
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: Text(
                        "Hapus",
                        style: GoogleFonts.raleway(),
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            constraint.maxWidth / 2,
                            constraint.maxHeight / 10,
                          ),
                          backgroundColor: Color.fromARGB(255, 253, 20, 55),
                          foregroundColor: Colors.white),
                    )
                  ],
                );
              }),
            ),
          );
        } else {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 1.3,
              child: LayoutBuilder(builder: (context, constraint) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Pelanggan bernama $namaPelanggan sudah memiliki riwayah penjualan, data tidak dapat dihapus",
                      style: GoogleFonts.raleway(
                          fontSize: constraint.maxWidth / 15),
                    ),
                    SizedBox(
                      height: constraint.maxHeight / 8,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        "Kembali",
                        style: GoogleFonts.raleway(),
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            constraint.maxWidth / 2,
                            constraint.maxHeight / 10,
                          ),
                          backgroundColor: Color.fromARGB(255, 20, 78, 253),
                          foregroundColor: Colors.white),
                    )
                  ],
                );
              }),
            ),
          );
        }
      });
}
