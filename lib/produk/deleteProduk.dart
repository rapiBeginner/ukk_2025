import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

deleteProduk(BuildContext context, int id, String namaProduk) {
  return showDialog(
      context: context,
      builder: (context) {
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
                    "$namaProduk akan di anggap sudah habis atau stoknya kosong",
                    style:
                        GoogleFonts.raleway(fontSize: constraint.maxWidth / 15),
                  ),
                  SizedBox(
                    height: constraint.maxHeight / 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Batal", style: GoogleFonts.raleway()),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var result = await Supabase.instance.client
                              .from("produk")
                              .update({"Stok": 0}).eq("ProdukID", id);
                          if (result == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 1000),
                              content: Text(
                                "Hapus produk berhasil",
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
                          
                            backgroundColor: Color.fromARGB(255, 20, 78, 253),
                            foregroundColor: Colors.white),
                      )
                    ],
                  )
                ],
              );
            }),
          ),
        );
      });
}
