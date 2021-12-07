// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter/material.dart';


import 'component/genColor.dart';
import 'component/genPreferrence.dart';
import 'component/request.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  var opacity = 0.0;
  String buildNumber = "";
  var dataUser;
  final req = new GenRequest();

  @override
  void initState() {
    super.initState();

  }


  @override
  dispose() {
    super.dispose();
  }


  cekLogin() async {
    var log = await getPrefferenceToken();

    print("lognya $log");
    var _duration = Duration(milliseconds: 2000);
    return Timer(_duration, () {
      log == "belumlogin"
          ? Navigator.pushReplacementNamed(context, "login")
          : getUser();
    });
  }

  startSplashScreen()  {
    print("checklogin");
    cekLogin();

    // var token = await getPrefferenceToken();
    // // var token = "asw";
    // if (token) {
    //   var duration = const Duration(milliseconds: 2000);
    //   return Timer(duration, () {
    //     Navigator.pushReplacementNamed(context, "loginPage");
    //   });
    // } else {
    //   var duration = const Duration(milliseconds: 2000);
    //   return Timer(duration, () {
    //     // Navigator.pushReplacementNamed(
    //     //     context, "welcome");
    //     Navigator.pushReplacementNamed(context, "base");
    //   });
    // }
  }

  startAnim(){
    Timer(Duration(milliseconds: 100),  (){ setState(() {
      opacity = 1.0;
    });});
  }

  bool loaded = false;
  @override
  Widget build(BuildContext context) {



    if(!loaded){
      startAnim();
      startSplashScreen();
      loaded = true;
    }

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/logo.png',
                width: 200,
                fit: BoxFit.fitWidth,
              ),
              // AnimatedOpacity(
              //   curve: Curves.easeIn,
              //   duration: Duration(milliseconds: 1000),
              //   opacity: opacity,
              //   child:
              //
              // ),
              SizedBox(height: 20,),
              Text("TikpeedKKU", style: TextStyle(color: GenColor.primaryColor, fontSize: 20),)

            ],
          ),
        ),
      ),
    );
  }

  void getUser() async {
    print("data usernya :");
    dataUser = await req.getApi("user");

    if (dataUser["role"] == "agen") {
      Navigator.pushReplacementNamed(context, "baseagen");
    } else {
      Navigator.pushReplacementNamed(context, "base");
    }

    print(dataUser);
    setState(() {});
  }
}
