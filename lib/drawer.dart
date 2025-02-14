import 'package:flutter/material.dart';

myDrawer(String username, String role) {
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
          onTap: (){},
          leading: Icon(Icons.person),
          title: Text("Pengguna"),
        ),
        ListTile(
          onTap: (){},
          leading: Icon(Icons.people),
          title: Text("Pelanggan"),
        ),
        ListTile(
          onTap: (){},
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
