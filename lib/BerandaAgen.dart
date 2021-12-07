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

import 'blocks/baseBloc.dart';
import 'component/NavDrawer.dart';
import 'component/commonPadding.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genShadow.dart';
import 'component/genText.dart';
import 'component/request.dart';
import 'component/textAndTitle.dart';

class BerandaAgen extends StatefulWidget {
  @override
  _BerandaAgenState createState() => _BerandaAgenState();
}

class _BerandaAgenState extends State<BerandaAgen> with WidgetsBindingObserver {
  Map dunmmyProfil = {
    "nama": "Colleen Alexander",
    "medal": 0,
    "koin": 0,
    "level": 0,
    "xp": 0,
    "up-level": 1000,
    "foto":
        "https://i1.hdslb.com/bfs/archive/1c619fbdf3fb4a2171598e17b7bee680d5fab2ff.png"
  };

  final req = new GenRequest();

  List listData = [
    {"id": 1, "hari": "senin"},
    {"id": 2, "hari": "selasa"},
    {"id": 3, "hari": "rabu"},
    {"id": 4, "hari": "kamis"},
    {"id": 5, "hari": "jumat"},
    {"id": 6, "hari": "sabtu"},
  ];

  List dummyPromo = [
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
  ];

//  VARIABEL

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  PageController gurulainController = PageController();
  var stateMetodBelajar = 1;
  var bloc;
  var clientId;
  var stateHari;
  var kelas, dariValue, keValue, totalpenumpang;
  dynamic dataJadwal;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getKelas();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

  getKelas() async {
    dataJadwal = await req.getApi("jadwal?id=1");
    // kelas = await getPrefferenceKelas();
    setState(() {});
  }

//  getClientId() async {
//    clientId = await getPrefferenceIdClient();
//    if (clientId != null) {
//      print("CLIENT ID" + clientId);
//    }
//  }

  getProfileAbsen() async {
    // await profileBloc.getProfile(reload: true);
  }

  String clienId;

//  getRoom() async {
//    clienId = await getPrefferenceIdClient();
//    return clienId;
//  }

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
    bloc = Provider.of<BaseBloc>(context);
    // notifbloc = Provider.of<NotifBloc>(context);

    // sendAnalyticsEvent(testLogAnalytic);
    // print("anal itik "+testLogAnalytic);

    if (!isLoaded) {
      isLoaded = true;
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
              height: 50,
            ),
            CommonPadding(
                child: GenText(
              "Jadwal kapal yang akan berangkat",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              CommonPadding(
                child: InkWell(

                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: GenShadow()
                            .genShadow(radius: 3.w, offset: Offset(0, 2.w))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          "https://img.inews.co.id/media/822/files/inews_new/2021/02/25/Screenshot_20210225_100311_Samsung_Internet.jpg",
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 15,),
                        CommonPadding(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        GenText("Asal", style: TextStyle( fontSize: 12),),
                                        SizedBox(height: 5,),
                                        GenText("Asal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Icon(Icons.arrow_forward),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        GenText("Tujuan", style: TextStyle( fontSize: 12),),
                                        SizedBox(height: 5,),
                                        GenText("Tujuan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              GenText("Tanggal Keberangkatan", style: TextStyle( fontSize: 12),),
                              SizedBox(height: 5,),
                              GenText("12 September 2021", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),


                              SizedBox(height: 20,),
                              GenButton(text: "Scan QR", padding: EdgeInsets.all(10), textSize: 16, ontap: (){
                                Navigator.pushNamed(context, "scanqr");
                              },)
                            ],
                          ),

                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                  ),
                ),
              )
            ])))
          ],
        ),
      ),
    );
  }

// void getJaddwal(id) async {
//   dataJadwal = await req.getApi("jadwal?id=" + id.toString());
//
//   print("DATA $dataJadwal");
//   print("length" +dataJadwal.length.toString());
//
//   setState(() {});
// }
}
