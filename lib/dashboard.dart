import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:raffi_ukk2025/decimal.dart';
import 'package:raffi_ukk2025/drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  final List login;
  const Dashboard({super.key, required this.login});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<_ChartData> data = [];
  List<CartesianData> data2 =[
    
  ];
  List penjualanHariIni = [];
  List penjualan2Hari = [];
  List penjualanKemarin = [];
  List pelanggan = [];
  List produkHabis = [];
  List<Map> produk = [];
  int pendapatanHariIni = 0;
  int pendapatanKemarin = 0;
  int pendapatan2hariLalu = 0;
  List penjualan = [];
  List produkHariIni = [];
  void fetchProduk() async {
    var result = await Supabase.instance.client
        .from('produk')
        .select()
        .order("ProdukID", ascending: true);
    setState(() {
      produk = result;
      produkHabis = produk.where((item) => item["Stok"] == 0).toList();
    });

    var result3 = await Supabase.instance.client.from("pelanggan").select();
    setState(() {
      pelanggan = result3;
    });
  }

  void fetchPenjualan() async {
    var result = await Supabase.instance.client.from("penjualan").select();
    setState(() {
      penjualanHariIni = result
          .where((item) =>
              item["TanggalPenjualan"] ==
              DateFormat("yyyy-MM-dd").format(DateTime.now()))
          .toList();

      for (var i = 0; i < penjualanHariIni.length; i++) {
        pendapatanHariIni += result[i]["TotalHarga"] as int;
      }

      penjualanKemarin = result
          .where((item) =>
              item["TanggalPenjualan"] ==
              DateFormat("yyyy-MM-dd")
                  .format(DateTime.now().subtract(Duration(days: 1))))
          .toList();

      for (var i = 0; i < penjualanKemarin.length; i++) {
        pendapatanKemarin += result[i]["TotalHarga"] as int;
      }

      penjualan2Hari = result
          .where((item) =>
              item["TanggalPenjualan"] ==
              DateFormat("yyyy-MM-dd")
                  .format(DateTime.now().subtract(Duration(days: 2))))
          .toList();

      for (var i = 0; i < penjualan2Hari.length; i++) {
        pendapatan2hariLalu += result[i]["TotalHarga"] as int;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProduk();
    fetchPenjualan();
  }

  @override
  Widget build(BuildContext context) {
    data = [
      _ChartData(
          "Platinum",
          pelanggan
              .where((item) => item["Membership"] == "platinum")
              .length
              .toDouble()),
      _ChartData(
          "Gold",
          pelanggan
              .where((item) => item["Membership"] == "gold")
              .length
              .toDouble()),
      _ChartData(
          "Silver",
          pelanggan
              .where((item) => item["Membership"] == "silver")
              .length
              .toDouble()),
    ];
    data2 = [
      CartesianData(
          DateFormat("dd-MM-yy")
              .format(DateTime.now().subtract(Duration(days: 2))),
          pendapatan2hariLalu),
      CartesianData(
          DateFormat("dd-MM-yy")
              .format(DateTime.now().subtract(Duration(days: 1))),
          pendapatanKemarin),
      CartesianData(
          DateFormat("dd-MM-yy").format(DateTime.now()), pendapatanHariIni),
    ];
    return Scaffold(
      drawer: myDrawer(context, widget.login[0]["Username"],
          widget.login[0]["Role"], widget.login),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 20, 78, 253),
        foregroundColor: Colors.white,
        title: Text("Dashboard", style: GoogleFonts.raleway(),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SfCircularChart(
                      title: ChartTitle(text: "Statistik membership", textStyle: GoogleFonts.raleway()),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      legend: Legend(isVisible: true),
                      series: <CircularSeries<_ChartData, String>>[
                        DoughnutSeries<_ChartData, String>(
                          dataSource: data,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: "Gold",
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        )
                      ],
                    ),
                    SfCartesianChart(
                      title: ChartTitle(text: "Statistik pendapatan", textStyle: GoogleFonts.raleway()),
                      primaryXAxis: CategoryAxis(),
                      series: <CartesianSeries<CartesianData, String>>[
                        LineSeries(
                          dataSource: data2,
                          xValueMapper: (CartesianData data2, _) => data2.tgl,
                          yValueMapper: (CartesianData data2, _) =>
                              data2.pendapatan,
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/15,),
                    Text("Data produk habis", style: GoogleFonts.raleway(fontWeight: FontWeight.bold)),
                    SizedBox(height: MediaQuery.of(context).size.height/20,),
                    Table(
                      border: TableBorder.all(borderRadius: BorderRadius.circular(10)),
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(5),
                      },
                      children: [
                        TableRow(
children: [
                                Center(child: Text("No", style: GoogleFonts.raleway())),
                                Center(
                                    child: Text(
                                        "Nama Produk", style: GoogleFonts.raleway())),
                                // Text(""),
                              ]
                        ),
                        ...List.generate(produkHabis.length, (index) {
                          return TableRow(
                              children: [
                                Center(child: Text("${index + 1}", style: GoogleFonts.raleway())),
                                Center(
                                    child: Text(
                                        "${produkHabis[index]["NamaProduk"]}", style: GoogleFonts.raleway())),
                                // Text(""),
                              ]);
                        })
                      ],
                    ),
                     SizedBox(height: MediaQuery.of(context).size.height/15,),
                    Text("Total pendapatan hari ini: Rp.${decimal(pendapatanHariIni.toString())}", style: GoogleFonts.raleway()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class CartesianData {
  CartesianData(this.tgl, this.pendapatan);

  final String tgl;
  final int pendapatan;
}
