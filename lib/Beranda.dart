// ignore: file_names
import 'dart:io';

import 'package:etiket/component/genButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'DetailPesanan.dart';
import 'blocks/baseBloc.dart';
import 'component/JustHelper.dart';
import 'component/NavDrawer.dart';
import 'component/commonPadding.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genShadow.dart';
import 'component/genText.dart';
import 'component/request.dart';
import 'component/textAndTitle.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with WidgetsBindingObserver {
  final req = new GenRequest();
  var startTime = TimeOfDay.fromDateTime(DateTime.now());
  var selectedDate = DateTime.now();

//  VARIABEL

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  PageController gurulainController = PageController();
  var stateMetodBelajar = 1;
  var kelas, keValue, totalpenumpang;
  String dariValue;
  dynamic dataKapal;

  Map pelabuhanAwal = {};
  Map pelabuhanAhkir = {};
  List<dynamic> dataPelabuhan;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        getKapal();
      });
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
    // notifbloc = Provider.of<NotifBloc>(context);

    // sendAnalyticsEvent(testLogAnalytic);
    // print("anal itik "+testLogAnalytic);

    if (!isLoaded) {
      isLoaded = true;
      getPelabuhan1();
    }

    // notifbloc.getTotalNotif();

    // bloc.util.getActiveOnline();
    // bloc.util.getNotifReview();

    // bloc.util.getRekomendasiAll("district", "level", 1, "limit", "offset");

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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "baseagen");
                      },
                      child: Icon(
                        Icons.notifications,
                        size: 26.0,
                      ),
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
              height: 50,
            ),
            CommonPadding(
                child: InkWell(
              onTap: () => _selectDate(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GenText("Tanggal"),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: GenShadow().genShadow(),
                        color: Colors.white),
                    child: GenText(formatTanggal(selectedDate).toString() ??
                        "Pilih Tanggal"),
                  ),
                ],
              ),
            )),
            SizedBox(
              height: 20,
            ),
            CommonPadding(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GenText("Asal"),
                        dataPelabuhan != null
                            ? DropdownButton<dynamic>(
                                value: dariValue,
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                isExpanded: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    dariValue = newValue;
                                    getPelabuhan2();
                                    getKapal();
                                  });
                                },
                                items: pelabuhanAwal
                                    .map((value, desc) {
                                      print("value " + value.toString());
                                      return MapEntry(
                                          desc,
                                          DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(desc),
                                          ));
                                    })
                                    .values
                                    .toList(),
                              )
                            : CircularProgressIndicator()
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GenText("Tujuan"),
                        dataPelabuhan != null
                            ? DropdownButton<dynamic>(
                                value: keValue,
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                isExpanded: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    keValue = newValue;
                                    getKapal();
                                  });
                                },
                                items: pelabuhanAhkir
                                    .map((value, desc) {
                                      print("value " + value.toString());
                                      return MapEntry(
                                          desc,
                                          DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(desc),
                                          ));
                                    })
                                    .values
                                    .toList(),
                              )
                            : CircularProgressIndicator()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CommonPadding(
                child: GenText(
              "Tiket yang tersedia",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: dataKapal == null
                    ? Center(
                  child: GenText("Pilih tanggal, asal dan tujuan"),
                )
                    : SingleChildScrollView(
                        child: Column(
                            children: dataKapal.map<Widget>((e) {
                        return CommonPadding(
                          child: InkWell(
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
                                    ip + e["kapal"]["image"].toString(),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  CommonPadding(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  GenText(
                                                    "Asal",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  GenText(
                                                    e["asal"]["nama"],
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
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  GenText(
                                                    e["tujuan"]["nama"],
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
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GenText(
                                          "Hari Keberangkatan",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        GenText(
                                          formatHari(e["hari"]) + ", " + e["jam"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GenText(
                                          "Penumpang",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              color: GenColor.primaryColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            DropdownButton<String>(
                                              value: totalpenumpang,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.deepPurple),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  totalpenumpang = newValue;
                                                });
                                              },
                                              items: <String>[
                                                '1',
                                                '2',
                                                '3',
                                                '4'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        GenButton(
                                          text: "Pesan Tiket",
                                          padding: EdgeInsets.all(10),
                                          textSize: 16,
                                          ontap: () {
                                            if(totalpenumpang == null){
                                              Toast.show("Jumlah penumpang belum di tentukan, silahkan isi jumlah penumpang", context);
                                            }else {
                                              Navigator.pushNamed(
                                                  context, "detailPesanan",
                                                  arguments: DetailPesanan(
                                                    idJadwal: e["id"].toString(),
                                                    jum_penumpang: totalpenumpang,
                                                    tanggal: selectedDate
                                                        .toString(),
                                                  ));
                                            }
                                          },
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
                          ),
                        );
                      }).toList())))
          ],
        ),
      ),
    );
  }

  void getKapal() async {
    if (selectedDate != null || dariValue != null || keValue != null) {
      dataKapal = await req.getApiUsingParams("user/kapal",
          {"tanggal": selectedDate, "asal": dariValue, "tujuan": keValue});

      print("DATA $dataKapal");
      print("length" + dataKapal.length.toString());

      setState(() {});
    }
  }

  void getPelabuhan1() async {
    dataPelabuhan = await req.getApi("user/pelabuhan");

    // dataKapal = await req.getApiUsingParams("user/kapal",
    //     {"id": 1});

    if (dataPelabuhan.length != 0) {
      for (var i = 0; i < (dataPelabuhan.length); i++) {
        print("pelabuhanAwal " + dataPelabuhan[i]["id"].toString());
        pelabuhanAwal[dataPelabuhan[i]["id"].toString()] =
            dataPelabuhan[i]["nama"];
      }
    }

    print("pelabuhanAwal $dataKapal");
    print("length" + pelabuhanAwal.length.toString());

    setState(() {});
  }

  void getPelabuhan2() async {
    dataPelabuhan = await req.getApi("user/pelabuhan?id=$dariValue");

    if (dataPelabuhan.length != 0) {
      for (var i = 0; i < (dataPelabuhan.length); i++) {
        print("pelabuhanAwal " + dataPelabuhan[i]["id"].toString());
        pelabuhanAhkir[dataPelabuhan[i]["id"].toString()] =
            dataPelabuhan[i]["nama"];
      }
    }

    print("pelabuhanAhkir $pelabuhanAhkir");
    print("length" + pelabuhanAhkir.length.toString());
    setState(() {});
  }
}
