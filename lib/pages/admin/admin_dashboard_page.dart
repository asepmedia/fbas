import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_fbase/pages/login_page.dart';
import 'package:latihan_fbase/widgets/add_lokasi_widget.dart';
import 'package:latihan_fbase/widgets/button_widget.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class BadgeWidget extends StatelessWidget {
  bool isActive = false;
  String label = "Rumah Sakit";
  BadgeWidget({
    super.key,
    this.isActive = false,
    this.label = "Rumah Sakit",
  });

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: Text(
          label,
          style:
              const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300)),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class InputWidget extends StatelessWidget {
  TextEditingController controller;
  int? maxLines;
  String? label;
  InputWidget({super.key, this.maxLines, this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label",
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          maxLines: maxLines,
          controller: controller,
          onSubmitted: (value) {},
          onTap: () {},
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            filled: true,
            fillColor: Colors.white,
            hintText: "$label",
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        )
      ],
    );
  }
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.242638190510166, 106.84342457481368),
    zoom: 19.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  bool _isCreate = false;

  final Completer<GoogleMapController> _controller = Completer();

  late LatLng _selectedLocation;
  late dynamic _selectedAddress;
  String jenisLayanan = "Rumah Sakit";
  LatLng _markerPosition = const LatLng(-6.242638190510166, 106.84342457481368);

  final TextEditingController _serviceNameC = TextEditingController();
  final TextEditingController _addressC = TextEditingController();

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/image/pin4.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Smart Village",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Container(
            child: Stack(
          children: [
            FutureBuilder(
                future: _getServices(),
                builder: (BuildContext context, snapshot) {
                  var data = snapshot.data
                      as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

                  return GoogleMap(
                    onTap: (LatLng latLng) {
                      setState(() {
                        _markerPosition = latLng;
                      });
                      setSelectedLocation(latLng);
                    },
                    mapType: MapType.terrain,
                    trafficEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    zoomControlsEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: <Marker>{
                      for (var item in data)
                        Marker(
                          markerId: MarkerId(item.id),
                          position: LatLng(item.data()['location'].latitude,
                              item.data()['location'].longitude),
                          infoWindow: InfoWindow(
                            title: item.data()['name'],
                            // snippet: item.data()['address'],
                          ),
                          icon: markerIcon,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Edit Layanan",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          item.data()['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          item.data()['address'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        ),
                      Marker(
                        draggable: true,
                        markerId: const MarkerId("1"),
                        position: _markerPosition,
                        icon: BitmapDescriptor.defaultMarker,
                        infoWindow: const InfoWindow(
                          title: 'Drag',
                        ),
                        onDragEnd: (value) {
                          print(value);
                          setSelectedLocation(value);
                        },
                      )
                    },
                  );
                }),
            // SafeArea(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Padding(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 30, vertical: 20),
            //             child: Container(
            //               width: double.infinity,
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 20, vertical: 20),
            //               decoration: BoxDecoration(
            //                   boxShadow: [
            //                     BoxShadow(
            //                       color: Colors.black.withOpacity(0.3),
            //                       blurRadius: 10,
            //                       offset: const Offset(0, 2),
            //                     ),
            //                   ],
            //                   color: Colors.white,
            //                   borderRadius:
            //                       const BorderRadius.all(Radius.circular(20))),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   const Text(
            //                     "Tambah Layanan",
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.w500, fontSize: 20),
            //                   ),
            //                   const SizedBox(height: 10),
            //                   Container(
            //                     padding: const EdgeInsets.symmetric(
            //                         vertical: 5, horizontal: 20),
            //                     decoration: BoxDecoration(
            //                       color: Colors.greenAccent.shade100,
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Text(
            //                       "Silakan drag & drop marker pada map untuk menentukan lokasi",
            //                       textAlign: TextAlign.center,
            //                       style:
            //                           TextStyle(color: Colors.green.shade900),
            //                     ),
            //                   ),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   InputWidget(
            //                     label: "Nama Layanan",
            //                     controller: _serviceNameC,
            //                   ),
            //                   const SizedBox(
            //                     height: 15,
            //                   ),
            //                   InputWidget(
            //                     label: "Alamat",
            //                     maxLines: 2,
            //                     controller: _addressC,
            //                   ),
            //                   const SizedBox(
            //                     height: 20,
            //                   ),
            //                   ButtonWidget(
            //                     height: 40,
            //                     child: const Text("Tambah Lokasi"),
            //                     onPressed: () async {
            //                       var db = FirebaseFirestore.instance;
            //                       db.collection("services").add({
            //                         "name": _serviceNameC.text,
            //                         "address": _addressC.text,
            //                         "location": GeoPoint(
            //                             _selectedLocation.latitude,
            //                             _selectedLocation.longitude)
            //                       });
            //                       showLoginAlertMsg(
            //                           "Sukses", "Lokasi berhasil ditambahkan");
            //                     },
            //                   )
            //                 ],
            //               ),
            //             ))
            //       ],
            //     ),
            //   ),
            // )
          ],
        )),
      ),
    );
  }

  Future<void> getAddressByCoordinate(LatLng latLng) async {
    final response = await http.get(Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude.toString()}&lon=${latLng.longitude.toString()}&format=json"));

    print(
        "https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude.toString()}&lon=${latLng.longitude.toString()}&format=json");
    if (response.statusCode == 200) {
      setState(() {
        _selectedAddress = json.decode(response.body);
      });

      _serviceNameC.text = _selectedAddress['name'];
      _addressC.text = _selectedAddress['display_name'];
      // If the server returns a 200 OK response, parse the JSON data
      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void setSelectedLocation(LatLng latLng) {
    getAddressByCoordinate(latLng);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AddLokasiWidget(
            selectedLocation: latLng,
          );
        });
  }

  void showLoginAlertMsg(final String title, final String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            // TextButton(
            //   child: const Text("RETURN"),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            ButtonWidget(
              height: 40,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  void toggleIsCreate() {
    setState(() {
      _isCreate = !_isCreate;
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _getServices() async {
    var db = await FirebaseFirestore.instance.collection("services").get();

    return db.docs;
  }
}
