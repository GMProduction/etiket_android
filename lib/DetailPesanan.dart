// ignore: file_names

import 'package:etiket/component/TextFieldLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'component/JustHelper.dart';
import 'component/NavDrawer.dart';
import 'component/commonPadding.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genText.dart';
import 'component/request.dart';

class DetailPesanan extends StatefulWidget {
  String idJadwal;
  String tanggal;
  String jum_penumpang;

  DetailPesanan({this.idJadwal, this.tanggal, this.jum_penumpang});

  @override
  _DetailPesananState createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan>
    with WidgetsBindingObserver {
  final req = new GenRequest();

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  var dataKapal;
  String nama1, nama2, nama3;
  String idJadwal;
  String tanggal;
  int jum_penumpang;
  String namaUser;

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

    final DetailPesanan args = ModalRoute.of(context).settings.arguments;
    idJadwal = args.idJadwal;
    tanggal = args.tanggal;
    jum_penumpang = int.parse(args.jum_penumpang);

    if (!isLoaded) {
      getUser();
      getKapal(idJadwal);
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
            Expanded(
              child: dataKapal == null
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            ip + dataKapal["kapal"]["image"],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CommonPadding(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GenText(
                                  dataKapal["kapal"]["nama"],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                GenText(
                                  dataKapal["kapal"]["keterangan"],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CommonPadding(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          GenText(
                                            "Asal",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          GenText(
                                            dataKapal["asal"]["nama"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
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
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          GenText(
                                            dataKapal["tujuan"]["nama"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
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
                                GenText(
                                  "Tanggal Keberangkatan",
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                GenText(
                                  formatTanggalFromString(tanggal),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                GenText(
                                  formatHari(dataKapal["hari"]) +
                                      ", " +
                                      dataKapal["jam"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GenText(
                                            "Penumpang",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.account_circle,
                                                color: GenColor.primaryColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GenText(
                                                jum_penumpang.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GenText(
                                            "Total Harga",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          GenText(
                                              formatRupiahUseprefik(
                                                      dataKapal["harga"] *
                                                          jum_penumpang)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                jum_penumpang > 1
                                    ? TextLoginField(
                                        initVal: "",
                                        width: double.infinity,
                                        label: "Nama tambahan penumpang 1",
                                        keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                                        onChanged: (val) {
                                          nama1 = val;
                                        },
                                        validator: (val) {
                                          if (val.length < 1) {
                                            return "Isi nama Dengan Benar";
                                          } else {
                                            return null;
                                          }
                                        },
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                jum_penumpang > 2
                                    ? TextLoginField(
                                        initVal: "",
                                        width: double.infinity,
                                        label: "Nama tambahan penumpang 2",
                                        keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                                        onChanged: (val) {
                                          nama2 = val;
                                        },
                                        validator: (val) {
                                          if (val.length < 1) {
                                            return "Isi nama Dengan Benar";
                                          } else {
                                            return null;
                                          }
                                        },
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                jum_penumpang > 3
                                    ? TextLoginField(
                                        initVal: "",
                                        width: double.infinity,
                                        label: "Nama tambahan penumpang 3",
                                        keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                                        onChanged: (val) {
                                          nama3 = val;
                                        },
                                        validator: (val) {
                                          if (val.length < 1) {
                                            return "Isi nama Dengan Benar";
                                          } else {
                                            return null;
                                          }
                                        },
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
            ),
            CommonPadding(
                child: GenButton(
              text: "Beli Tiket",
              ontap: () {
                beliTiket();
              },
            )),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }

  void beliTiket() async {
    List dataPenumpang = [];

    if (jum_penumpang == 1) {
      dataPenumpang = [namaUser];
    } else if (jum_penumpang == 2) {
      dataPenumpang = [namaUser, nama1];
    } else if (jum_penumpang == 3) {
      dataPenumpang = [namaUser, nama1, nama2];
    } else if (jum_penumpang == 4) {
      dataPenumpang = [namaUser, nama1, nama2, nama3];
    }

    var statusPembelian = await req.postApiJsonAuth("user/pesanan",
        {"nama": dataPenumpang, "id_jadwal": idJadwal, "tanggal": tanggal});
    print("statusPembelian $statusPembelian");

    if (statusPembelian == "Berhasil") {
      var checkout = await req.getApi("user/pesanan/checkout");

      if (checkout == "Berhasil") {
        Navigator.pushReplacementNamed(context, "tagihan");
      }
      print("checkout $checkout");
    }
  }

  void getKapal(id) async {
    dataKapal = await req.getApiUsingParams("user/kapal", {"id": 1});

    dataKapal = dataKapal[0];

    print("DATA $dataKapal");
    print("length" + dataKapal.length.toString());

    setState(() {});
  }

  void getUser() async {
    print("data usernya :");
    var User = await req.getApi("user");

    namaUser = User["name"];

    print(User);
    setState(() {});
  }
}
