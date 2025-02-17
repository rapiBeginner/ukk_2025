import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List produkHabis = [];
  List<Map> produk = [];
  int totalPendapatan = 0;
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

    var result2 = await Supabase.instance.client
        .from("penjualan")
        .select("*,detailpenjualan(*, produk(*))")
        .eq("TanggalPenjualan",
            DateFormat("yyyy-MM-dd").format(DateTime.now()));
    setState(() {
      penjualan = result2;
      // for (var i = 0; i < penjualan.length; i++) {
      //   List detailPenjualan=penjualan[i]["detailpenjualan"];
      //   for (var i = 0; i < detailPenjualan.length; i++) {
      //    List produkDetail= detailPenjualan[i]["produk"];
      //    for (var i = 0; i < produkDetail.length; i++) {
      //       var check=produkHariIni.where((item)=>item==produkDetail[i][""]);
      //     if (check.isEmpty) {
      //       produkHariIni.add({
      //         "ProdukID":detailPenjualan[i]["produk"]["ProdukID"],
      //         "NamaProduk":detailPenjualan[i]["produk"]["NamaProduk"]
      //       });
      //     }
      //    }
      //   }
      // }
      print(produkHariIni);
    });
  }

  void fetchTodaySales() async {
    var result = await Supabase.instance.client
        .from("penjualan")
        .select("TotalHarga")
        .eq("TanggalPenjualan",
            DateFormat("yyyy-MM-dd").format(DateTime.now()));
    for (var i = 0; i < result.length; i++) {
      totalPendapatan += result[i]["TotalHarga"] as int;
    }
    // print(totalPendapatan);
  }

  @override
  void initState() {
    super.initState();
    data = [
      _ChartData("Rafi", 2),
      _ChartData("irfan", 5),
    ];
    fetchProduk();
    fetchTodaySales();
  }

  @override
  Widget build(BuildContext context) {
    // print(produk);
    return Scaffold(
      drawer: myDrawer(context, widget.login[0]["Username"],
          widget.login[0]["Role"], widget.login),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 20, 78, 253),
        foregroundColor: Colors.white,
        title: Text("Dashboard"),
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
                    Text("Data produk habis"),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(5),
                      },
                      children: [
                        ...List.generate(produkHabis.length, (index) {
                          return TableRow(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              children: [
                                Center(child: Text("${index + 1}")),
                                Center(
                                    child: Text(
                                        "${produkHabis[index]["NamaProduk"]}")),
                                // Text(""),
                              ]);
                        })
                      ],
                    ),
                    Text("Total pendapatan hari ini: Rp.${totalPendapatan}"),
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
