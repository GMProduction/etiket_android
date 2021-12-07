import 'package:flutter/material.dart';

import 'genColor.dart';

class MenuNavbar {
  const MenuNavbar(this.title, this.icon);
  final String title;
  final IconData icon;
}

const List<MenuNavbar> allDestinations = <MenuNavbar>[
  MenuNavbar('Pesan Tiket', Icons.home_outlined),
  MenuNavbar('Tagihan', Icons.assignment),
  MenuNavbar('Pesanan', Icons.history),
  MenuNavbar('Profil', Icons.account_box_outlined),
];