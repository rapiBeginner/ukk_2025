import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raffi_ukk2025/dashboard.dart';
import 'package:raffi_ukk2025/main.dart';
import 'package:raffi_ukk2025/pelanggan.dart/pelangganIndex.dart';
import 'package:raffi_ukk2025/penjualan/penjualanIndex.dart';
import 'package:raffi_ukk2025/produk/produkIndex.dart';
import 'package:raffi_ukk2025/user/userIndex.dart';

myDrawer(BuildContext context, String username, String role, List login) {
  return Drawer(
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Color.fromARGB(255, 20, 78, 253)),
          accountName: Text(username),
          accountEmail: Text(role),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(username.characters.first),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(login: login)));
          },
          leading: Icon(Icons.stacked_bar_chart),
          title: Text("Dashboard"),
        ),
        role == "admin"
            ? ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Userindex(login: login)));
                },
                leading: Icon(Icons.person),
                title: Text("Pengguna"),
              )
            : SizedBox(),
        ListTile(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Pelangganindex(login: login)));
          },
          leading: Icon(Icons.people),
          title: Text("Pelanggan"),
        ),
        ListTile(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Produkindex(login: login)));
          },
          leading: Icon(Icons.card_travel),
          title: Text("Produk"),
        ),
        role == "petugas"
            ? ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Penjualanindex(login: login)));
                },
                leading: Icon(Icons.shopping_cart),
                title: Text("Penjualan"),
              )
            : SizedBox(),
        ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Anda yakin ingin logout?"),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Batal",
                                  style: GoogleFonts.raleway(),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()));
                                },
                                child: Text(
                                  "Logout",
                                  style: GoogleFonts.raleway(),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 20, 78, 253),
                                    foregroundColor: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          leading: Icon(Icons.logout),
          title: Text("Logout"),
        ),
      ],
    ),
  );
}
