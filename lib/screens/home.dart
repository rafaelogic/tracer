import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.people),
            onPressed: () {
              Navigator.pushNamed(context, '/persons');
            }),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [buildHeader(), buildDev()],
              ),
              buildImageHeader(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [buildScanQrButton(context), buildRegisterButton(context)],
              ),
            ],
          ),
        ));
  }
}

Widget buildHeader() => Text(
      'SNCES Tracer',
      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40, color: Colors.blueAccent.shade400),
      textAlign: TextAlign.center,
    );

Widget buildImageHeader() => Center(
      child: Image(image: AssetImage('assets/images/home.jpg')),
    );

Widget buildDev() => Text(
      'Developed By: \n Diosa Faith D. Rafael, RN, LPT, MAED \n Copyright © 2021',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
    );

Widget buildScanQrButton(context) => TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/scan-qr');
      },
      child: Column(children: <Widget>[
        Icon(
          Icons.qr_code_2_outlined,
          size: 42,
        ),
        Text("Scan QR Code", style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500))
      ]),
      style: TextButton.styleFrom(backgroundColor: Colors.white, elevation: 1),
    );

Widget buildRegisterButton(context) => TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/add-person');
      },
      child: Column(children: <Widget>[
        Icon(
          Icons.person_add,
          size: 42,
        ),
        Text("Register Visitor", style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500))
      ]),
      style: TextButton.styleFrom(backgroundColor: Colors.white, elevation: 1),
    );
