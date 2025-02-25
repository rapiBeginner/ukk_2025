import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

editProduk(BuildContext context, String nama, int harga, int stok, int Id) {
  final formKey = GlobalKey<FormState>();
  final namaCtrl = TextEditingController(text: nama);
  final hargaCtrl = TextEditingController(text: harga.toString());
  final stokCtrl = TextEditingController(text: stok.toString());

  produkEdit() async {
    if (formKey.currentState!.validate()) {
      var checkProduk = await Supabase.instance.client
          .from("produk")
          .select()
          .like("NamaProduk", namaCtrl.text)
          .neq("ProdukID", Id);
      if (checkProduk.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text(
            "Produk ini sudah tersedia",
            style: GoogleFonts.raleway(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        var result = await Supabase.instance.client.from("produk").update({
          "NamaProduk": namaCtrl.text,
          "Harga": hargaCtrl.text,
          "Stok": stokCtrl.text
        }).eq("ProdukID", Id);
        if (result == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text(
              "Edit produk berhasil",
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
                height: MediaQuery.of(context).size.height / 1.7,
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
                              "Edit Produk",
                              style: GoogleFonts.raleway(
                                  fontSize: constraint.maxWidth / 15),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 15,
                            ),
                            TextFormField(
                              controller: namaCtrl,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Nama produk tidak boleh kosong";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Nama produk",
                                  labelStyle: GoogleFonts.raleway(),
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 25,
                            ),
                            TextFormField(
                              controller: hargaCtrl,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Harga tidak boleh kosong";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Harga",
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 25,
                            ),
                            TextFormField(
                              controller: stokCtrl,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Stok tidak boleh kosong";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Stok",
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Batal",
                                      style: GoogleFonts.raleway()),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    produkEdit();
                                  },
                                  child: Text(
                                    "Simpan",
                                    style: GoogleFonts.raleway(),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 20, 78, 253),
                                      foregroundColor: Colors.white),
                                )
                              ],
                            )
                          ],
                        )),
                  );
                })),
          );
        });
      });
}
