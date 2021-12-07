import 'package:etiket/QRcode.dart';
import 'package:etiket/baseagen.dart';
import 'package:etiket/pembangunan.dart';
import 'package:etiket/pembayaran.dart';
import 'package:etiket/profil.dart';
import 'package:etiket/propertymu.dart';
import 'package:etiket/scanqr.dart';
import 'package:etiket/tagihan.dart';
import 'package:etiket/transaksi.dart';
import 'package:provider/provider.dart';


import 'DetailPesanan.dart';
import 'base.dart';
import 'blocks/baseBloc.dart';
import 'daftar.dart';
import 'keterangan.dart';
import 'login.dart';
import 'splashScreen.dart';

class GenProvider {
  static var providers = [
    ChangeNotifierProvider<BaseBloc>.value(value: BaseBloc()),

  ];

  static routes(context) {
    return {
//           '/': (context) {
//        return Base();
//      },

      '/': (context) {
        return SplashScreen();
      },

      'splashScreen': (context) {
        return SplashScreen();
      },

      'login': (context) {
        // return Login();
        return Login();
      },

      'daftar': (context) {
        // return Login();
        return Daftar();
      },

      'propertymu': (context) {
        // return Login();
        return Propertymu();
      },

      'base': (context) {
        // return Login();
        return Base();
      },


      'pembangunan': (context) {
        return Pembangunan();
      },

      'keterangan': (context) {
        return Keterangan();
      },

      'profil': (context) {
        return Profil();
      },

      'detailPesanan': (context) {
        return DetailPesanan();
      },

      'pembayaran': (context) {
        return Pembayaran();
      },

      'qrcode': (context) {
        return QRCode();
      },

      'scanqr': (context) {
        return ScanQR();
      },

      'baseagen': (context) {
        // return Login();
        return BaseAgen();
      },

      'transaksi': (context) {
        // return Login();
        return Transaksi();
      },

      'tagihan': (context) {
        // return Login();
        return Tagihan();
      },

    };
  }
}
