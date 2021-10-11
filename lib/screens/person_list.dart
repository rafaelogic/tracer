import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tracer/models/person.dart';
import 'package:tracer/providers/log_provider.dart';
import 'package:tracer/providers/person_provider.dart';

class PersonList extends StatefulWidget {
  const PersonList({Key? key}) : super(key: key);

  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SNCES Visitors'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.insights_outlined),
            onPressed: () async {
              int? personCount = await PersonProvider.instance.count();
              int? logCount = await LogProvider.instance.count();

              showMenu(context: context, position: RelativeRect.fill, items: [
                PopupMenuItem(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.people_alt_outlined,
                          color: Colors.blue,
                        ),
                        Text(
                          "  $personCount",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "  Total registered visitors",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.login_rounded,
                          color: Colors.blue,
                        ),
                        Text(
                          "  $logCount",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "  Total QR log entries",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ],
                )),
              ]);
            },
          )
        ],
      ),
      body: FutureBuilder<List<Person>>(
          future: PersonProvider.instance.persons(),
          builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    Person person = snapshot.data![index];

                    return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          color: Colors.red.shade600,
                          child: Text(
                            "Swipe to delete",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        onDismissed: (direction) {
                          PersonProvider.instance.delete(person.id!);
                        },
                        child: ListTile(
                          isThreeLine: true,
                          title: Text(
                            "${person.firstName} ${person.lastName}",
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Text(
                            "0${person.mobileNumber} \n${person.address}",
                            style: TextStyle(color: Colors.black87),
                          ),
                          trailing: GestureDetector(
                            onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: Text(
                                      "${person.firstName} ${person.lastName}",
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Container(
                                      width: 280,
                                      height: 280,
                                      child: QrImage(
                                        data: jsonEncode(person.toJson()),
                                      ),
                                    ))),
                            child: QrImage(
                              data: jsonEncode(person.toJson()),
                            ),
                          ),
                          onLongPress: () {
                            setState(() {});
                            Navigator.popAndPushNamed(context, '/add-person', arguments: person);
                          },
                          onTap: () {
                            Navigator.pushNamed(context, '/logs', arguments: person);
                          },
                        ));
                  });
            } else {
              return Center(child: Text('You haven\'t registered a person yet.'));
            }
          }),
    );
  }
}
