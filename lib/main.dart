import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'detectMylocation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Find Location'),
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
  String allAdressLine;

  List latResults = [];
  List lngResults = [];
  List addressResults = [];

  List isSelected = [];

  final streetAndNumberController = TextEditingController();
  final postalCodeController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool selectDeviceGps = false;
  bool selectAddressLineBox = false;
  double distance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
              // decoration: BoxDecoration(border: Border.all()),
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "You can detect latitude and longtitude datas with using device gps sensor or using address line fetched from Here Maps API service. \n\nPlease select the method",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (selectDeviceGps == false) {
                        setState(() {
                          selectDeviceGps = true;
                        });
                      } else {
                        setState(() {
                          selectDeviceGps = false;
                        });
                      }
                    },
                    child: Container(
                      color: Colors.indigo.shade100,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Device Location",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              selectAddressLineBox == false
                                  ? Icon(Icons.arrow_drop_down)
                                  : Icon(Icons.arrow_drop_up)
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  if (selectDeviceGps == true)
                    Center(
                      child: RaisedButton(
                        onPressed: () async {
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            duration: new Duration(seconds: 1),
                            content: new Row(
                              children: <Widget>[
                                new CircularProgressIndicator(),
                                new SizedBox(
                                  width: 20,
                                ),
                                new Text("Adding your gps data...")
                              ],
                            ),
                          ));
                          Position position = await getDeviceLocation();
                          setState(() {
                            latResults.add(position.latitude);
                            lngResults.add(position.longitude);
                            addressResults.add("Device GPS");
                            isSelected.add(0);
                          });

                          AlertDialog(
                            actions: [CircularProgressIndicator()],
                          );

                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Added')));
                        },
                        color: Colors.orange.shade300,
                        child: Text("Find My Location"),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (selectAddressLineBox == false) {
                        setState(() {
                          selectAddressLineBox = true;
                        });
                      } else {
                        setState(() {
                          selectAddressLineBox = false;
                        });
                      }
                    },
                    child: Container(
                      color: Colors.indigo.shade100,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Find Location with Address Line",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              selectAddressLineBox == false
                                  ? Icon(Icons.arrow_drop_down)
                                  : Icon(Icons.arrow_drop_up)
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  if (selectAddressLineBox == true)
                    Container(
                      // color: Colors.indigo.shade50,
                      child: Padding(
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
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic)),
                                onSaved: (value) {},
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
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
                                              color: Colors.black,
                                              fontSize: 16.0)),
                                      onSaved: (value) {},
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: postalCodeController,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.label_important),
                                          hintText: "Postal Code",
                                          hintStyle: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black,
                                              fontSize: 16.0)),
                                      onSaved: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: TextFormField(
                                      controller: stateController,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.label_important),
                                          hintText: "State",
                                          hintStyle: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black,
                                              fontSize: 16.0)),
                                      onSaved: (value) {},
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
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
                                              color: Colors.black,
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
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(new SnackBar(
                                      duration: new Duration(seconds: 1),
                                      content: new Row(
                                        children: <Widget>[
                                          new CircularProgressIndicator(),
                                          new SizedBox(
                                            width: 20,
                                          ),
                                          new Text("Fetching data...")
                                        ],
                                      ),
                                    ));
                                    setState(() {
                                      allAdressLine =
                                          "${streetAndNumberController.text}&city=${cityController.text}&state=${stateController.text}&postalcode=${postalCodeController.text}&country=${countryController.text}"
                                              .replaceAll(" ", "+");
                                    });

                                    try {
                                      var snapshot =
                                          await findLocation(allAdressLine);

                                      setState(() {
                                        latResults.add(snapshot.lat);
                                        lngResults.add(snapshot.lng);
                                        isSelected.add(0);
                                        addressResults.add(
                                            "${streetAndNumberController.text}, ${cityController.text}, ${stateController.text}, ${postalCodeController.text}, ${countryController.text}");
                                      });

                                      AlertDialog(
                                        actions: [CircularProgressIndicator()],
                                      );

                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text('Added')));

                                      streetAndNumberController.clear();
                                      cityController.clear();
                                      stateController.clear();
                                      postalCodeController.clear();
                                      countryController.clear();
                                    } catch (e) {
                                      AlertDialog(
                                        actions: [CircularProgressIndicator()],
                                      );

                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  Text('Error. Try Again')));
                                    }
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      color: Colors.orange.shade300,
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Center(
                                    child: Text(
                                      "Find Location",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (lngResults.length > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1.7),
                    2: FlexColumnWidth(1.7),
                    3: FlexColumnWidth(3.1),
                  },
                  border: TableBorder.all(
                      color: Colors.black, style: BorderStyle.solid, width: 1),
                  children: [
                    TableRow(children: [
                      Column(children: [
                        Text('#',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                      Column(children: [
                        Text('Latitude',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                      Column(children: [
                        Text('Longtitude',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                      Column(children: []),
                    ]),
                  ],
                ),
              ),
            if (lngResults.length > 0)
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: latResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1.7),
                          2: FlexColumnWidth(1.7),
                          3: FlexColumnWidth(3.1),
                        },
                        border: TableBorder.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1),
                        children: [
                          TableRow(children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState
                                        .hideCurrentSnackBar();
                                    _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                            // behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 10),
                                            backgroundColor:
                                                Colors.indigo.shade100,
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Text(
                                                    "${index + 1}: " +
                                                        addressResults[index],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                RaisedButton(
                                                  color: Colors.orange.shade300,
                                                  onPressed: () {
                                                    Clipboard.setData(ClipboardData(
                                                        text:
                                                            "${addressResults[index]}"));
                                                  },
                                                  child: Text(
                                                    "Copy",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _scaffoldKey.currentState
                                                        .hideCurrentSnackBar();
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              ],
                                            )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('${index + 1}.',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                        Icon(
                                          Icons.info_outlined,
                                          color: Colors.orange.shade700,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(children: [
                              Text('${latResults[index]}',
                                  style: TextStyle(fontSize: 16.0))
                            ]),
                            Column(children: [
                              Text('${lngResults[index]}',
                                  style: TextStyle(fontSize: 16.0))
                            ]),
                            Column(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (isSelected[index] == 0) {
                                          setState(() {
                                            isSelected[index] = 1;
                                          });
                                        } else {
                                          setState(() {
                                            isSelected[index] = 0;
                                            distance = null;
                                          });
                                        }
                                      },
                                      child: isSelected[index] == 0
                                          ? Column(
                                              children: [
                                                Icon(
                                                  Icons.check_box_outline_blank,
                                                  size: 28,
                                                  color: Colors.blue.shade700,
                                                ),
                                                Text("Select"),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Icon(
                                                  Icons.check_box_outlined,
                                                  size: 28,
                                                  color: Colors.blue.shade700,
                                                ),
                                                Text("Unselect"),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text:
                                                "${latResults[index]},${lngResults[index]}"));

                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                                duration: Duration(seconds: 1),
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                  'Locations are copied.',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )));
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.copy,
                                            size: 28,
                                            color: Colors.blue.shade700,
                                          ),
                                          Text("Copy"),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          latResults.removeAt(index);
                                          lngResults.removeAt(index);
                                          addressResults.removeAt(index);
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.remove_circle,
                                            size: 28,
                                            color: Colors.red.shade700,
                                          ),
                                          Text("Remove"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ]),
                        ],
                      ),
                    );
                  }),
            if (lngResults.length > 0)
              SizedBox(
                height: 20,
              ),
            _bottomMenu(),
            SizedBox(
              height: 40,
            ),
          ]),
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

  Widget _bottomMenu() {
    List onlySelectedIndexes = [];

    for (var i = 0; i < latResults.length; i++) {
      if (isSelected[i] == 1) {
        setState(() {
          onlySelectedIndexes.add(i);
        });
        print(onlySelectedIndexes);
      }
    }
    // print(onlySelectedIndexes);

    return Container(
      // decoration: BoxDecoration(border: Border.all()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            onlySelectedIndexes.length > 1
                ? Text(
                    onlySelectedIndexes.length.toString() +
                        " addresses are selected.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                : Text(
                    onlySelectedIndexes.length.toString() +
                        " address is selected.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
            Divider(
              color: Colors.black,
              height: 1.5,
            ),
            Row(
              children: [
                if (onlySelectedIndexes.length == 2)
                  RaisedButton(
                    onPressed: () {
                      double startLatitude = latResults[onlySelectedIndexes[0]];
                      double startLongitude =
                          lngResults[onlySelectedIndexes[0]];
                      double endLatitude = latResults[onlySelectedIndexes[1]];
                      double endLongitude = lngResults[onlySelectedIndexes[1]];

                      setState(() {
                        distance = measureDistance(startLatitude,
                            startLongitude, endLatitude, endLongitude);
                      });
                    },
                    child: Text("Measure Distance"),
                    color: Colors.orange.shade300,
                  ),
                SizedBox(
                  width: 5,
                ),
                if (onlySelectedIndexes.length == 2)
                  RaisedButton(
                    onPressed: () {},
                    child: Text("Route on Map"),
                    color: Colors.orange.shade300,
                  ),
                SizedBox(
                  width: 5,
                ),
                if (onlySelectedIndexes.length == 1)
                  RaisedButton(
                    onPressed: () {},
                    child: Text("Show on Map"),
                    color: Colors.orange.shade300,
                  )
              ],
            ),
            if (onlySelectedIndexes.length == 2 && distance != null)
              Text(
                "${num.parse((distance / 1000).toStringAsFixed(2))} km",
                // distance.truncateToDouble().toString() + " meters",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
          ],
        ),
      ),
    );
  }
}
