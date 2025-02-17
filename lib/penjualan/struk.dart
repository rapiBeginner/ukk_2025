import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:printing/printing.dart';
import 'package:raffi_ukk2025/drawer.dart';

class Struk extends StatefulWidget {
  final List login;
  final Map penjualan;
  const Struk({super.key, required this.login, required this.penjualan});

  @override
  State<Struk> createState() => _StrukState();
}

class _StrukState extends State<Struk> {
  @override
  void initState() {
    super.initState();
    print(widget.penjualan);
  }

  @override
  Widget build(BuildContext context) {
    Map penjualan = widget.penjualan;
    List detail = widget.penjualan["detailpenjualan"];
    return Scaffold(
      drawer: myDrawer(context, widget.login[0]["Username"],
          widget.login[0]["Role"], widget.login),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Struk Pembelian",
          style: GoogleFonts.raleway(),
        ),
        backgroundColor: Color.fromARGB(255, 20, 78, 253),
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
          initialPageFormat: PdfPageFormat.roll57,
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          build: (format) async {
            final fontBold = await PdfGoogleFonts.ralewayBlack();
            final font= await PdfGoogleFonts.ralewayLight();
            var pdf = pdfWidget.Document();
            pdf.addPage(pdfWidget.Page(build: (context) {
              return pdfWidget.Column(
                  mainAxisAlignment: pdfWidget.MainAxisAlignment.center,
                  children: [
                    pdfWidget.Text(
                        "Tanggal transaksi${penjualan["TanggalPenjualan"]}",
                        style: pdfWidget.TextStyle(font: font, fontSize: 30)),
                    ...List.generate(detail.length, (index) {
                      return pdfWidget.Row(children: [
                        pdfWidget.Text(
                            "${detail[index]["produk"]["NamaProduk"]} (${detail[index]["JumlahProduk"]})",
                            style:
                                pdfWidget.TextStyle(font: font, fontSize: 30)),
                        pdfWidget.Spacer(),
                        pdfWidget.Text("Rp.${detail[index]["Subtotal"]}",
                            style:
                                pdfWidget.TextStyle(font: font, fontSize: 30)),
                      ]);
                    }), pdfWidget.Row(children: [
                        pdfWidget.Text(
                            "Total",
                            style:
                                pdfWidget.TextStyle(font: fontBold, fontSize: 30)),
                        pdfWidget.Spacer(),
                        pdfWidget.Text("Rp.${penjualan["TotalHarga"]}",
                            style:
                                pdfWidget.TextStyle(font: fontBold, fontSize: 30)),
                      ])
                  ]);
            }));
            return pdf.save();
          }),
    );
  }
}
