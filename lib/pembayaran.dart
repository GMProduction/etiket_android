import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'component/JustHelper.dart';
import 'component/TextFieldLogin.dart';
import 'component/commonPadding.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genPreferrence.dart';
import 'component/genText.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class Pembayaran extends StatefulWidget {
  int id;

  Pembayaran({this.id});

  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  bool readyToHit = true;
  final req = new GenRequest();

  bool isLoaded = false;

  var email, password;
  var _picker, id, dataPesanan, dataJadwal;
  XFile _image;

  Future<XFile> pickImage() async {
    final _picker = ImagePicker();

    final XFile pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      print('PickedFile: ${pickedFile.toString()}');
      setState(() {
        _image = XFile(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }

    if (_image != null) {
      return _image;
    }
    return null;
  }

  void takepic() async {
    final XFile photo = await _picker.pickImage(source: ImageSource.camera);
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.files != null) {
      for (final XFile file in response.files) {
        // _handleFile(file);
      }
    } else {
      // _handleError(response.exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Pembayaran args = ModalRoute.of(context).settings.arguments;
    id = args.id;

    if (!isLoaded) {
      getTagihan(id);
      isLoaded = true;
    }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Pembayaran",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: dataJadwal == null
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    ip + dataJadwal["kapal"]["image"],
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
                                        GenText(
                                          dataJadwal["kapal"]["nama"],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GenText(
                                          dataJadwal["kapal"]["keterangan"],
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
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  GenText(
                                                    dataJadwal["asal"]["nama"],
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
                                                    dataJadwal["tujuan"]
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
                                        GenText(
                                          "Tanggal Keberangkatan",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        GenText(
                                          // formatTanggalFromString(dataJadwal),
                                          "tanggal",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        GenText(
                                          formatHari(dataJadwal["hari"]) +
                                              ", " +
                                              dataJadwal["jam"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GenText(
                                                    "Penumpang",
                                                    style:
                                                        TextStyle(fontSize: 12),
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
                                                        color: GenColor
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      GenText(
                                                        "",
                                                        // jum_penumpang.toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  GenText(
                                                      formatRupiahUseprefik(
                                                              dataPesanan[
                                                                  "total_harga"])
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
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
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: dataPesanan["pesanan"]
                                                  .map<Widget>((i) {
                                                return GenText(i["nama"]);
                                              }).toList(),
                                            )
                                          ],
                                        ),
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      children: [
                        _image == null
                            ? Container(
                                width: 100,
                                height: 100,
                              )
                            : Image.file(
                                File(_image.path),
                                width: 100,
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: GenButton(
                            color: Colors.grey,
                            text: "Upload Bukti",
                            ontap: () {
                              pickImage();
                            },
                          ),
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
            readyToHit
                ? GenButton(
                    text: "SUBMIT",
                    ontap: () {
                      // login(email, password);
                      upLoadBukti(id, _image);
                    },
                  )
                : CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void getTagihan(id) async {
    print("id  $id");
    dataPesanan = await req.getApi("user/pembayaran/" + id.toString());
    print("DATA $dataPesanan");

    if (dataPesanan != null) {
      dataJadwal = await req.getApi(
          "user/kapal/" + dataPesanan["pesanan"][0]["id_jadwal"].toString());

      print("dataJadwal" + dataJadwal.toString());
    }

    setState(() {});
  }

  void upLoadBukti(
      id,
      bukti
      ) async {

    String fileName = bukti.path.split('/').last;


    setState(() {
      readyToHit = false;
    });
    dynamic data;
    data = await req.postForm("user/pembayaran/"+id.toString(), {
      "image":
      await MultipartFile.fromFile(bukti.path, filename:fileName)
    });

    print(data);

    setState(() {
      readyToHit = true;
    });

    if (data != null) {
      setState(() {
        toastShow("Bukti berhasil di upload", context, Colors.black);
        Navigator.pushReplacementNamed(context, "base");

      });

    } else {
      setState(() {
        toastShow(data.toString(), context, GenColor.red);
      });
    }
  }
}
