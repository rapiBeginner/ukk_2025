import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

addPenjualan(BuildContext context, List produk, List pelanggan) {
  final pelangganCtrl = SingleValueDropDownController();
  List produkBeli = [];
  int totalHarga = 0;
  produkAdd(){
    return showDialog(context: context, builder: (context){
      return Dialog(
        child: StatefulBuilder(builder: (context, setState){
          return Column(
            
          );
        }),
      );
    });
  }
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(child: StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height / 1.7,
            width: MediaQuery.of(context).size.width / 1.3,
            child: LayoutBuilder(builder: (context, constraint) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tambah Pelanggan",
                    style:
                        GoogleFonts.raleway(fontSize: constraint.maxWidth / 15),
                  ),
                  SizedBox(
                    height: constraint.maxHeight / 15,
                  ),
                  DropDownTextField(controller: pelangganCtrl, dropDownList: [
                    ...List.generate(pelanggan.length, (index) {
                      return DropDownValueModel(
                          name:
                              "${pelanggan[index]["NamaPelanggan"]}/${pelanggan[index]["NomorTelepon"]}",
                          value: pelanggan[index]["PelangganID"]);
                    })
                  ]),
                  SizedBox(
                    height: constraint.maxHeight / 20,
                  ),
                  Container(
                    height: constraint.maxHeight / 1.5,
                    width: constraint.maxWidth / 1.3,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    child: produkBeli.isEmpty
                        ? null
                        : ListView(
                            children: [
                              ...List.generate(produkBeli.length, (index) {
                                return ListTile(
                                  title: Text(
                                      "${produkBeli[index]["NamaProduk"]} (${produkBeli[index]["JumlahBeli"]})"),
                                  subtitle: Text(
                                      "Rp.${produkBeli[index]["Subtotal"].toString()}"),
                                  trailing: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            produkBeli.removeAt(index);
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.close)),
                                );
                              })
                            ],
                          ),
                  ),
                  SizedBox(
                    height: constraint.maxHeight / 20,
                  ),
                  Row(
                    children: [
                      Text("Rp.${totalHarga.toString()}"),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {

                          }, child: Text("Tambah produk"))
                    ],
                  ),
                ],
              );
            }),
          );
        }));
      });
}
