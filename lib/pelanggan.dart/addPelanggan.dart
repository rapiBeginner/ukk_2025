import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

addPelanggan(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final namaCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  final noTelpCtrl = TextEditingController();

  pelangganAdd() async {
    if (formKey.currentState!.validate()) {
      var checkProduk = await Supabase.instance.client
          .from("pelanggan")
          .select()
          .like("NamaPelanggan", namaCtrl.text)
          .like("Alamat", alamatCtrl.text)
          .like("NomorTelepon", noTelpCtrl.text);
      if (checkProduk.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text(
            "Pelanggan ini sudah terdaftar",
            style: GoogleFonts.raleway(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        var result = await Supabase.instance.client.from("pelanggan").insert([
          {
            "NamaPelanggan": namaCtrl.text,
            "Alamat": alamatCtrl.text,
            "NomorTelepon": noTelpCtrl.text
          }
        ]);
        if (result == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text(
              "Pendaftaran pelanggan berhasil",
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
                height: MediaQuery.of(context).size.height / 1.6,
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
                              "Tambah Pelanggan",
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
                                  return "Nama pelanggan tidak boleh kosong";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Nama pelanggan",
                                  labelStyle: GoogleFonts.raleway(),
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 25,
                            ),
                            TextFormField(
                              controller: alamatCtrl,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Alamat tidak boleh kosong";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Alamat",
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 25,
                            ),
                            TextFormField(
                              controller: noTelpCtrl,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Nomor telepon tidak boleh kosong";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Nomor telepon",
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 25,
                            ),
                            // DropDownTextField(dropDownList: [
                            //   DropDownValueModel(
                            //       name: "Platinum", value: "platinum"),
                            //   DropDownValueModel(
                            //       name: "Platinum", value: "platinum"),
                            //   DropDownValueModel(
                            //       name: "Platinum", value: "platinum"),
                            // ]),
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
                                    pelangganAdd();
                                  },
                                  child: Text(
                                    "Simpan",
                                    style: GoogleFonts.raleway(),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 20, 78, 253),
                                      foregroundColor: Colors.white),
                                ),
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
