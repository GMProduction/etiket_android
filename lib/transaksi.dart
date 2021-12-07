// ignore: file_names
import 'dart:io';

import 'package:etiket/QRcode.dart';
import 'package:etiket/component/JustHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'blocks/baseBloc.dart';
import 'component/NavDrawer.dart';
import 'component/commonPadding.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genShadow.dart';
import 'component/genText.dart';
import 'component/request.dart';
import 'component/textAndTitle.dart';

class Transaksi extends StatefulWidget {
  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> with WidgetsBindingObserver {
  final req = new GenRequest();

//  VARIABEL

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;
  var dataPesanan;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    // notifbloc.dispose();
    // bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GenColor.primaryColor, // status bar color
    ));

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);

    if (!isLoaded) {
      getPesanan();
      isLoaded = true;
    }

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GenColor.primaryColor,
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, "notifikasi", arguments: );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 26.0,
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            CommonPadding(
                child: GenText(
              "Riwayat Pesanan",
              style: TextStyle(fontSize: 25),
            )),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: dataPesanan.length == 0
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                            children: dataPesanan.map<Widget>((e) {
                        return CommonPadding(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: GenShadow().genShadow(
                                    radius: 3.w, offset: Offset(0, 2.w))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  ip + e["kapal"]["kapal"]["image"],
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                CommonPadding(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GenText(
                                                e["pesanan"]["nama"],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              e["pesanan"]["status"] == 1
                                                  ? GenText(
                                                      "Tiket Belum dipakai",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.green),
                                                    )
                                                  : GenText(
                                                      "Tiket Sudah dipakai",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.red),
                                                    ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              GenText(
                                                formatTanggalFromString(
                                                    e["pesanan"]["tanggal"]),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              GenText(
                                                e["kapal"]["jam"].toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GenText(
                                            e["kapal"]["kapal"]["nama"],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GenText(e["kapal"]["kapal"]
                                              ["keterangan"]),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      CommonPadding(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Divider(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      GenText(
                                                        "Asal",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      GenText(
                                                        e["kapal"]["asal"]
                                                            ["nama"],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(Icons.arrow_forward),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      GenText(
                                                        "Tujuan",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      GenText(
                                                        e["kapal"]["tujuan"]
                                                            ["nama"],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            e["pesanan"]["status"] == 2 ? Container() :
                                            GenButton(
                                              text: "QR Code",
                                              padding: EdgeInsets.all(10),
                                              textSize: 16,
                                              ontap: () {
                                                Navigator.pushNamed(
                                                    context, "qrcode", arguments: QRCode(
                                                  kode: e["pesanan"]["kode_tiket"]
                                                ));
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList())))
          ],
        ),
      ),
    );
  }

  void getPesanan() async {
    dataPesanan = [];

    var dataPembayaran = await req.getApi("user/pembayaran");

    if (dataPembayaran != null) {
      if (dataPembayaran.length > 0) {
        for (var i = 0; i < dataPembayaran.length; i++) {
          if (dataPembayaran[i]["status"] == 1) {
            var idJ = dataPembayaran[i]["pesanan"][i]["id_jadwal"];
            var dataKapal = await req.getApi("user/kapal/$idJ");
            for (var j = 0; j < dataPembayaran[i]["pesanan"].length; j++) {
              dataPesanan.add({
                "pesanan": dataPembayaran[i]["pesanan"][j],
                "kapal": dataKapal
              });
            }
          }
        }
      }
    }

    print("DATA $dataPesanan");
    print("length" + dataPesanan.length.toString());

    setState(() {});
  }
}
