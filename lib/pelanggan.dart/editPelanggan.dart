import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

editPelanggan(BuildContext context, String nama, String alamat, String noTelp,
    String member, int Id) {
  final formKey = GlobalKey<FormState>();
  final namaCtrl = TextEditingController(text: nama);
  final alamatCtrl = TextEditingController(text: alamat);
  final noTelpCtrl = TextEditingController(text: noTelp);
  final memberCtrl = SingleValueDropDownController(
      data: DropDownValueModel(name: member, value: member));

  pelangganEdit() async {
    if (formKey.currentState!.validate()) {
      var checkProduk = await Supabase.instance.client
          .from("pelanggan")
          .select()
          .like("NamaPelanggan", namaCtrl.text)
          .like("Alamat", alamatCtrl.text)
          .like("NomorTelepon", noTelpCtrl.text)
          .neq("PelangganID", Id);
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
        var result = await Supabase.instance.client.from("pelanggan").update({
          "NamaPelanggan": namaCtrl.text,
          "Alamat": alamatCtrl.text,
          "NomorTelepon": noTelpCtrl.text,
          "Membership": memberCtrl.dropDownValue!.value
        }).eq("PelangganID", Id);
        if (result == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text(
              "Edit pelanggan berhasil",
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
                height: MediaQuery.of(context).size.height / 1.2,
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
                              "Edit Pelanggan",
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
                                var regex = RegExp(r'^08\d*$');
                                if (value == null || value.isEmpty) {
                                  return "Nomor telepon tidak boleh kosong";
                                } else if (!regex.hasMatch(value)) {
                                  return "nomor telepon diawali 08";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Nomor telepon",
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: constraint.maxHeight / 20,
                            ),
                            DropDownTextField(
                                textFieldDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Pilih paket membership",
                                    labelStyle: GoogleFonts.raleway()),
                                controller: memberCtrl,
                                dropDownList: [
                                  DropDownValueModel(
                                      name: "silver", value: "silver"),
                                  DropDownValueModel(
                                      name: "gold", value: "gold"),
                                  DropDownValueModel(
                                      name: "platinum", value: "platinum"),
                                ]),
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
                                    pelangganEdit();
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
