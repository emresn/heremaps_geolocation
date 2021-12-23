import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import 'detect_my_location.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Find Location'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? allAdressLine;

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
  double? distance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(widget.title!),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "You can detect latitude and longitude datas with using device gps sensor or using address line fetched from Here Maps API service. \n\nPlease select the method",
                    style: TextStyle(),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(
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
                            const Text(
                              "My Device Location",
                              style: TextStyle(),
                            ),
                            selectAddressLineBox == false
                                ? const Icon(Icons.arrow_drop_down)
                                : const Icon(Icons.arrow_drop_up)
                          ],
                        )),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                if (selectDeviceGps == true)
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Row(
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Adding your gps data...")
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

                        const AlertDialog(
                          actions: [CircularProgressIndicator()],
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Added')));
                      },
                      child: const Text("Find My Location"),
                    ),
                  ),
                const SizedBox(
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
                            const Text(
                              "Find Location with Address Line",
                              style: TextStyle(),
                            ),
                            selectAddressLineBox == false
                                ? const Icon(Icons.arrow_drop_down)
                                : const Icon(Icons.arrow_drop_up)
                          ],
                        )),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                if (selectAddressLineBox == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            controller: streetAndNumberController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an address';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                icon: Icon(Icons.label_important),
                                hintText: "Street, House Number, District",
                                hintStyle: TextStyle()),
                            onSaved: (value) {},
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: TextFormField(
                                  controller: cityController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a City';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.label_important),
                                      hintText: "City",
                                      hintStyle: TextStyle()),
                                  onSaved: (value) {},
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: postalCodeController,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.label_important),
                                      hintText: "Postal Code",
                                      hintStyle: TextStyle()),
                                  onSaved: (value) {},
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: TextFormField(
                                  controller: stateController,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.label_important),
                                      hintText: "State",
                                      hintStyle: TextStyle()),
                                  onSaved: (value) {},
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: TextFormField(
                                  controller: countryController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a country';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.label_important),
                                      hintText: "Country",
                                      hintStyle: TextStyle()),
                                  onSaved: (value) {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Row(
                                    children: const <Widget>[
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Fetching data...")
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

                                  const AlertDialog(
                                    actions: [CircularProgressIndicator()],
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text('Added')));

                                  streetAndNumberController.clear();
                                  cityController.clear();
                                  stateController.clear();
                                  postalCodeController.clear();
                                  countryController.clear();
                                } catch (e) {
                                  const AlertDialog(
                                    actions: [CircularProgressIndicator()],
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text('Error. Try Again')));
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Colors.orange.shade300,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Center(
                                child: Text(
                                  "Find Location",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ])),
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (lngResults.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(
                      color: Colors.black, style: BorderStyle.solid, width: 1),
                  children: [
                    TableRow(children: [
                      Column(children: const [Text('#', style: TextStyle())]),
                      Column(children: const [
                        Text('Latitude',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ]),
                      Column(children: const [
                        Text('Longitude',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ]),
                    ]),
                  ],
                ),
              ),
            if (lngResults.isNotEmpty)
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: latResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1),
                        children: [
                          TableRow(children: [
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        // behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 10),
                                        backgroundColor: Colors.indigo.shade100,
                                        content: Column(
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                "${index + 1}: " +
                                                    addressResults[index],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text:
                                                        "${addressResults[index]}"));
                                              },
                                              child: const Text(
                                                "Copy",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                "copied")));
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                            )
                                          ],
                                        )));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${index + 1}.',
                                      style: const TextStyle()),
                                  Icon(
                                    Icons.info_outlined,
                                    color: Colors.orange.shade700,
                                  ),
                                ],
                              ),
                            ),
                            Text('${latResults[index]}',
                                style: const TextStyle()),
                            Text('${lngResults[index]}',
                                style: const TextStyle()),
                            Column(
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
                                              color: Colors.blue.shade700,
                                            ),
                                            const Text("Select"),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            Icon(
                                              Icons.check_box_outlined,
                                              color: Colors.blue.shade700,
                                            ),
                                            const Text("Unselect"),
                                          ],
                                        ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "${latResults[index]},${lngResults[index]}"));

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            duration: Duration(seconds: 1),
                                            backgroundColor: Colors.green,
                                            content: Text(
                                              'Locations are copied.',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )));
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.copy,
                                        color: Colors.blue.shade700,
                                      ),
                                      const Text("Copy"),
                                    ],
                                  ),
                                ),
                                const SizedBox(
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
                                        color: Colors.red.shade700,
                                      ),
                                      const Text("Remove"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ],
                      ),
                    );
                  }),
            if (lngResults.isNotEmpty)
              const SizedBox(
                height: 20,
              ),
            _bottomMenu(),
            const SizedBox(
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
        // print(onlySelectedIndexes);
      }
    }
    // print(onlySelectedIndexes);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          onlySelectedIndexes.length > 1
              ? Text(
                  onlySelectedIndexes.length.toString() +
                      " addresses are selected.",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )
              : Text(
                  onlySelectedIndexes.length.toString() +
                      " address is selected.",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
          const Divider(
            color: Colors.black,
            height: 1.5,
          ),
          Row(
            children: [
              if (onlySelectedIndexes.length == 2)
                ElevatedButton(
                  onPressed: () {
                    double? startLatitude = latResults[onlySelectedIndexes[0]];
                    double? startLongitude = lngResults[onlySelectedIndexes[0]];
                    double? endLatitude = latResults[onlySelectedIndexes[1]];
                    double? endLongitude = lngResults[onlySelectedIndexes[1]];

                    setState(() {
                      distance = measureDistance(startLatitude!,
                          startLongitude!, endLatitude!, endLongitude!);
                    });
                  },
                  child: const Text("Measure Distance"),
                ),
              const SizedBox(
                width: 5,
              ),
              if (onlySelectedIndexes.length == 2)
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Route on Map"),
                ),
              const SizedBox(
                width: 5,
              ),
              if (onlySelectedIndexes.length == 1)
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Show on Map"),
                )
            ],
          ),
          if (onlySelectedIndexes.length == 2 && distance != null)
            Text(
              "${num.parse((distance! / 1000).toStringAsFixed(2))} km",
              // distance.truncateToDouble().toString() + " meters",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            )
        ],
      ),
    );
  }
}
