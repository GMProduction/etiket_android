import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'component/TextFieldLogin.dart';
import 'component/commonPadding.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genText.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class ProfilAgen extends StatefulWidget {
  @override
  _ProfilAgenState createState() => _ProfilAgenState();
}

class _ProfilAgenState extends State<ProfilAgen> {
  bool readyToHit = true;
  final req = new GenRequest();
  var name, email, nim, jurusan, stateKelas;
  dynamic dataUser;


  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              GenText(
                "Profil",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),

              TextLoginField(
                initVal:  name,
                width: double.infinity,
                label: "Nama",
                keyboardType: TextInputType.text,
//                                    controller: tecNumber,

                onChanged: (val) {
                  name = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Nama Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextLoginField(
                initVal: jurusan,
                width: double.infinity,
                label: "Alamat",
                keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                onChanged: (val) {
                  jurusan = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Jurusan Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),


              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: email,
                width: double.infinity,
                label: "No. HP",
                keyboardType: TextInputType.emailAddress,
//                                    controller: tecNumber,
                onChanged: (val) {
                  email = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Email Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              readyToHit
                  ? GenButton(
                      text: "UBAH",
                      ontap: () {

                      },
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }


  // void getUser() async {
  //   dataUser = await req.getApi("user");
  //
  //   name = dataUser["data"]["name"];
  //   email = dataUser["data"]["email"];
  //   stateKelas = dataUser["data"]["kelas"];
  //   nim = dataUser["data"]["nim"].toString();
  //   jurusan = dataUser["data"]["jurusan"];
  //
  //   print(dataUser);
  //   print(name);
  //   setState(() {});
  // }
}
