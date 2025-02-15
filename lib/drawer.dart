import 'package:flutter/material.dart';
import 'package:raffi_ukk2025/produk/produkIndex.dart';
import 'package:raffi_ukk2025/user/userIndex.dart';

myDrawer( BuildContext context, String username, String role, List login) {
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
        )
        ,ListTile(
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Userindex(login: login)));},
          leading: Icon(Icons.person),
          title: Text("Pengguna"),
        ),
        ListTile(
          onTap: (){},
          leading: Icon(Icons.people),
          title: Text("Pelanggan"),
        ),
        ListTile(
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Produkindex(login: login)));},
          leading: Icon(Icons.card_travel),
          title: Text("Produk"),
        ),
        ListTile(
          onTap: (){},
          leading: Icon(Icons.shopping_cart),
          title: Text("Penjualan"),
        ),
      ],
    ),
  );
}
