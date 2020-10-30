import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'detectMylocation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Here Maps Find Location',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Here Maps Find Location'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showResult = false;
  String allAdressLine;
  String latResult;
  String lngResult;
  final streetAndNumberController = TextEditingController();
  final postalCodeController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Address Information",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Divider(
                  height: 2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                          controller: streetAndNumberController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              icon: Icon(Icons.label_important),
                              hintText: "Street, House Number, District",
                              hintStyle: TextStyle(
                                  fontSize: 16.0, fontStyle: FontStyle.italic)),
                          onSaved: (value) {},
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextFormField(
                                controller: cityController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a City';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    icon: Icon(Icons.label_important),
                                    hintText: "City",
                                    hintStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16.0)),
                                onSaved: (value) {},
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: postalCodeController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.label_important),
                                    hintText: "Postal Code",
                                    hintStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16.0)),
                                onSaved: (value) {},
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextFormField(
                                controller: stateController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.label_important),
                                    hintText: "State",
                                    hintStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16.0)),
                                onSaved: (value) {},
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextFormField(
                                controller: countryController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a country';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    icon: Icon(Icons.label_important),
                                    hintText: "Country",
                                    hintStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16.0)),
                                onSaved: (value) {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                allAdressLine =
                                    "${streetAndNumberController.text}&city=${cityController.text}&state=${stateController.text}&postalcode=${postalCodeController.text}&country=${countryController.text}"
                                        .replaceAll(" ", "+");
                                showResult = true;
                              });
                            }
                          },
                          onDoubleTap: () {
                            setState(() {
                              showResult = false;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Center(
                              child: Text(
                                "Find Location",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (showResult == true)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your Location:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    "(Lat, Lng)",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  FutureBuilder<Location>(
                                    future: findLocation(allAdressLine),
                                    builder: (context, snapshot) {
                                      try {
                                        if (snapshot.hasData) {
                                          latResult =
                                              snapshot.data.lat.toString();
                                          lngResult =
                                              snapshot.data.lng.toString();

                                          return Text(
                                            "${snapshot.data.lat}, ${snapshot.data.lng}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text("error");
                                        }

                                        // By default, show a loading spinner.
                                        return CircularProgressIndicator();
                                      } catch (e) {
                                        return Text("error");
                                      }
                                    },
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: "$latResult,$lngResult"));

                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              backgroundColor: Colors.green,
                                              content: Text('Copied')));
                                    },
                                    child: Text(
                                      "Copy to Clipboard",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        countryController.clear();
                                        cityController.clear();
                                        postalCodeController.clear();
                                        streetAndNumberController.clear();
                                        stateController.clear();
                                        showResult = false;
                                      });
                                    },
                                    child: Text(
                                      "Clear Forms",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                      ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
    countryController.dispose();
    stateController.dispose();
    streetAndNumberController.dispose();
    postalCodeController.dispose();
  }
}
