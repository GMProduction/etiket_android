// ignore: file_names
import 'dart:io';

import 'package:etiket/component/genToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'blocks/baseBloc.dart';
import 'component/JustHelper.dart';
import 'component/NavDrawer.dart';
import 'component/commonPadding.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genShadow.dart';
import 'component/genText.dart';
import 'component/request.dart';
import 'component/textAndTitle.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> with WidgetsBindingObserver {
  final req = new GenRequest();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  PageController gurulainController = PageController();
  var stateMetodBelajar = 1;
  var bloc;
  var clientId;
  var stateHari;
  var kelas;
  dynamic dataScan;
  bool readyToScan = true;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        scan(result.code);
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // analytics.

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  getRoom() async {
//    clienId = await getPrefferenceIdClient();
//    return clienId;
//  }

  @override
  void dispose() {
    controller?.dispose();
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
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                  child: readyToScan
                      ? GenText("scan Tiket")
                      : GenButton(
                          radius: 0,
                          text: "Scan Lagi",
                          ontap: () {
                            setState(() {
                              readyToScan = true;
                            });
                          },
                        )),
            )
          ],
        ),
      ),
    );
  }

  void scan(id) async {
    if (readyToScan) {
      dataScan = await req.getApi("agen/scan-qr?id=" + id.toString());

      if (dataScan != null) {
        toastShow(dataScan.toString(), context, Colors.black);
        readyToScan = false;
      }
      print("DATA $dataScan");
      print("length" + dataScan.length.toString());

      setState(() {});
    }
  }
}
