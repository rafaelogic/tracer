import 'package:flutter/cupertino.dart';
import 'package:tracer/screens/add_person.dart';
import 'package:tracer/screens/person_list.dart';
import 'package:tracer/screens/qr_scanner.dart';
import 'package:tracer/screens/visit_log.dart';

var tracerRoutes = <String, WidgetBuilder>{
  '/add-person': (context) => const AddPerson(),
  '/persons': (context) => PersonList(),
  '/logs': (context) => VisitLog(),
  '/scan-qr': (context) => ScanQr()
};
