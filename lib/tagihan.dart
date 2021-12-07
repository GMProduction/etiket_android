// ignore: file_names
import 'dart:io';

import 'package:etiket/component/JustHelper.dart';
import 'package:etiket/pembayaran.dart';
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

class Tagihan extends StatefulWidget {
  @override
  _TagihanState createState() => _TagihanState();
}

class _TagihanState extends State<Tagihan> with WidgetsBindingObserver {
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
      getTagihan();
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
              "Riwayat Tagihan",
              style: TextStyle(fontSize: 25),
            )),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: dataPesanan == null
                    ? Center(
                        child: GenText("Belum ada tagihan..."),
                      )
                    : SingleChildScrollView(
                        child: Column(children: dataPesanan.map<Widget>((e) {
                          return e["status"] == 1 ? Container() : CommonPadding(
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

                                  CommonPadding(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GenText(
                                              e["pesanan"][0]["tanggal"],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            GenText(
                                              formatRupiahUseprefik(e["total_harga"].toString()),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
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
                                              "Daftar Penumpang",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Column(crossAxisAlignment: CrossAxisAlignment.start,children: e["pesanan"].map<Widget>((i){
                                              return GenText(i["nama"]);
                                            }).toList(),)
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      GenButton(text: "Bayar Sekarang",
                                        ontap: (){
                                        Navigator.pushNamed(context, "pembayaran",
                                          arguments: Pembayaran(
                                          id: e["id"],
                                          ));
                        }
                                      )
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

  void getTagihan() async {
    dataPesanan = await req.getApi("user/pembayaran");



    print("DATA $dataPesanan");
    print("length" + dataPesanan.length.toString());

    setState(() {});
  }
}
