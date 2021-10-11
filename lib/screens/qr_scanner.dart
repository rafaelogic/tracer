import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tracer/models/log.dart';
import 'package:tracer/providers/log_provider.dart';
import 'package:tracer/providers/person_provider.dart';
import 'package:tracer/models/person.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  bool isRegistered = true;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQRView(context),
              Positioned(bottom: 10, child: scanQr(context)),
              Positioned(top: 10, child: buildControlButtons())
            ],
          ),
        ),
      );

  Widget buildQRView(BuildContext context) => QRView(
        key: _qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.blue,
            borderRadius: 10,
            borderLength: 20,
            borderWidth: 10,
            cutOutSize: MediaQuery.of(context).size.width * 0.8),
      );

  Widget scanQr(BuildContext context) => Container(
          child: IconButton(
        icon: Icon(Icons.qr_code),
        iconSize: 42,
        color: Colors.white,
        onPressed: () async {
          try {
            if (this.result != null) {
              var codeJson = jsonDecode(this.result!.code);
              var code = Person.fromJson(codeJson);

              Person? person = await PersonProvider.instance.getByName(code.firstName, code.lastName);

              if (person != null) {
                DateTime now = new DateTime.now();
                LogProvider.instance.add(Log(personId: person.id, date: now.toIso8601String()));

                ArtDialogResponse response = await ArtSweetAlert.show(
                    context: context,
                    barrierDismissible: false,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.success,
                        title: "Success!",
                        text:
                            "${code.firstName} ${code.lastName} visit log is successfully recorded to SNCES tracer app.",
                        confirmButtonText: "OK"));

                if (response == null) return;

                if (response.isTapConfirmButton) {
                  Navigator.of(context).popAndPushNamed('/logs', arguments: person);
                }
              } else {
                ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.info,
                        title: "Not registered",
                        text: "This person is not yet registered to your SNCES tracer app."));
              }
            } else {
              ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.danger,
                      title: "Unknown SNCES QR Code",
                      text: "Please make it sure that you are capturing a correct SNCES QR code."));
            }
          } catch (e) {
            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(type: ArtSweetAlertType.danger, title: "Error", text: e.toString()));
          }
        },
      ));

  Widget buildControlButtons() => Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(snapshot.data! ? Icons.flash_on : Icons.flash_off);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                try {
                  await controller?.toggleFlash();
                  setState(() {});
                } catch (e) {
                  ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                          type: ArtSweetAlertType.danger, title: "Camera Flash Error", text: e.toString()));
                }
              },
            ),
          ],
        ),
      );

  void onQRViewCreated(QRViewController qrViewController) async {
    setState(() => this.controller = qrViewController);

    qrViewController.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}
