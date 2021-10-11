import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracer/models/person.dart';
import 'package:tracer/providers/person_provider.dart';

class AddPerson extends StatefulWidget {
  const AddPerson({Key? key}) : super(key: key);

  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final mobileNumberEditingController = TextEditingController();
  final addressEditingController = TextEditingController();

  int? _mobileNumber;
  String? _firstName;
  String? _lastName;
  String? _address;

  late FocusNode firstNode;

  @override
  void initState() {
    super.initState();
    firstNode = FocusNode();
  }

  @override
  void dispose() {
    firstNameEditingController.dispose();
    lastNameEditingController.dispose();
    mobileNumberEditingController.dispose();
    addressEditingController.dispose();
    firstNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Person? _person;
    String mode = 'create';

    if (ModalRoute.of(context)!.settings.arguments != null) {
      _person = ModalRoute.of(context)!.settings.arguments as Person;

      mode = 'update';

      firstNameEditingController.text = _person.firstName!;
      lastNameEditingController.text = _person.lastName!;
      mobileNumberEditingController.text = _person.mobileNumber.toString();
      addressEditingController.text = _person.address!;
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(mode == 'update' ? 'Edit Visitor Info' : 'Register A Visitor'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildFirstNameField(),
                _buildLastNameField(),
                _buildPhoneNumberField(),
                _buildAddressField(),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _firstName = firstNameEditingController.text;
                      _lastName = lastNameEditingController.text;
                      _mobileNumber = int.parse(mobileNumberEditingController.text);
                      _address = addressEditingController.text;

                      if (mode == 'create') {
                        await PersonProvider.instance.add(
                          Person(
                              firstName: _firstName,
                              lastName: _lastName,
                              mobileNumber: _mobileNumber,
                              address: _address),
                        );
                      } else {
                        await PersonProvider.instance.update(Person(
                            id: _person!.id,
                            firstName: _firstName,
                            lastName: _lastName,
                            mobileNumber: _mobileNumber,
                            address: _address));
                      }

                      if (mode == 'create') {
                        final snackBar = SnackBar(
                            content: Text("$_firstName $_lastName sucessfully added to SNCES Tracer."),
                            action: SnackBarAction(label: 'close', onPressed: () => {}));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        _formKey.currentState!.reset();
                        firstNameEditingController.text = "";
                        lastNameEditingController.text = "";
                        mobileNumberEditingController.text = "";
                        addressEditingController.text = "";
                      } else {
                        final snackBar = SnackBar(
                            elevation: 5,
                            backgroundColor: Colors.blue.shade400,
                            content: Text("$_firstName $_lastName's info sucessfully updated."),
                            action: SnackBarAction(label: 'close', textColor: Colors.white54, onPressed: () => {}));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.popAndPushNamed(context, '/persons');
                      }
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: firstNameEditingController,
      decoration: InputDecoration(labelText: 'First Name'),
      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[a-zA-z ]"))],
      focusNode: firstNode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'First Name is required.';
        }

        if (value.length < 2) {
          return "First Name should at least have 2 characters.";
        }

        return null;
      },
      onSaved: (value) {
        if (value != null) {
          _firstName = value;
        }
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: lastNameEditingController,
      decoration: InputDecoration(labelText: 'Last Name'),
      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[a-zA-z ]"))],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Last Name is required.';
        }

        if (value.length < 2) {
          return "Last Name should at least have 2 characters.";
        }

        return null;
      },
      onSaved: (value) {
        if (value != null) {
          _lastName = value;
        }
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: mobileNumberEditingController,
      decoration: InputDecoration(labelText: 'Mobile Number'),
      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Mobile Number is required.';
        }

        if (value.length < 10) {
          return 'Mobile Number is invalid. It should be 11 digits.';
        }

        // if (value.length > 11) {
        //   return 'Mobile Number is invalid. It should only have 11 digits.';
        // }

        return null;
      },
      onSaved: (value) {
        if (value != null) {
          _mobileNumber = int.tryParse(value);
        }
      },
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: addressEditingController,
      decoration: InputDecoration(labelText: 'Address'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Address is required.';
        }

        if (value.length < 2) {
          return "Address should at least have 2 characters.";
        }

        return null;
      },
      onSaved: (value) {
        if (value != null) {
          _address = value;
        }
      },
    );
  }
}
