import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracer/models/log.dart';
import 'package:tracer/models/person.dart';
import 'package:tracer/providers/log_provider.dart';

class VisitLog extends StatefulWidget {
  const VisitLog({Key? key}) : super(key: key);

  @override
  _VisitLogState createState() => _VisitLogState();
}

class _VisitLogState extends State<VisitLog> {
  @override
  Widget build(BuildContext context) {
    //
    // Left intentionally for testing purposes...
    //
    // DateTime now = new DateTime.now();
    // LogProvider.instance.add(Log(personId: 19, date: now.toIso8601String()));
    // LogProvider.instance.add(Log(personId: 19, date: now.toIso8601String()));

    Person? person;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      person = ModalRoute.of(context)!.settings.arguments as Person;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${person!.firstName}'s Visit Log"),
        leading: new IconButton(icon: new Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.of(context).popAndPushNamed('/scan-qr'), icon: Icon(Icons.qr_code_2_rounded))
        ],
      ),
      body: FutureBuilder<List<Log>>(
        future: LogProvider.instance.getAllLogsByPerson(person.id),
        builder: (BuildContext context, AsyncSnapshot<List<Log>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isNotEmpty) {
            return Scrollbar(
                interactive: true,
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Log log = snapshot.data![index];

                      var logDate = DateTime.parse(log.date!);
                      var date = DateFormat.yMd().add_jm().format(logDate);

                      return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                          child: ListTile(
                            leading: Icon(
                              Icons.login_rounded,
                              color: Colors.blue,
                            ),
                            tileColor: Colors.white,
                            title: Text(
                              "$date",
                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w300),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                LogProvider.instance.delete(log.id!);
                                setState(() {});
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red.shade600,
                              ),
                            ),
                          ));
                    }));
          } else {
            return Center(child: Text("No logs found for ${person!.firstName} ${person.lastName}."));
          }
        },
      ),
    );
  }
}
