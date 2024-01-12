import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latihan_fbase/widgets/button_widget.dart';
import 'package:latihan_fbase/widgets/filter_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.242638190510166, 106.84342457481368),
    zoom: 11,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  int _currentIndex = 0;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerHospitalIcon = BitmapDescriptor.defaultMarker;
  String jenisLayanan = "";
  GoogleMapController? mapController; //contrller for Google map

  List<QueryDocumentSnapshot<Map<String, dynamic>>> locations = [];

  List<String> filtereds = [];

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

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/image/hospital.png")
        .then(
      (icon) {
        setState(() {
          markerHospitalIcon = icon;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: _getServices(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data
                      as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
                  locations = data;

                  return GoogleMap(
                    mapType: MapType.terrain,
                    trafficEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(data[0].data()['location'].latitude,
                          data[0].data()['location'].longitude),
                      zoom: 11,
                    ),
                    zoomControlsEnabled: false,
                    markers: {
                      for (var item in locations)
                        if (filtereds.contains(item.id) || filtereds.isEmpty)
                          Marker(
                            markerId: MarkerId(item.id),
                            position: LatLng(item.data()['location'].latitude,
                                item.data()['location'].longitude),
                            infoWindow: InfoWindow(
                              title: item.data()['name'],
                              // snippet: item.data()['address'],
                            ),
                            icon: item.data()['type'] == "Rumah Sakit"
                                ? markerHospitalIcon
                                : markerIcon,
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child:
                                          ListView(shrinkWrap: true, children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Detail Layanan",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            const SizedBox(height: 10),
                                            if (item.data()['image'] != null)
                                              Image.network(
                                                  item.data()['image']),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Layanan",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              item.data()['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18),
                                            ),
                                            if (item.data()['phone'] != null)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 15),
                                                  const Text(
                                                    "Kontak",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    item.data()['phone'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            if (item.data()['description'] !=
                                                null)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 15),
                                                  const Text(
                                                    "Deskiprsi",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    item.data()['description'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            item.data()['type'] == "Rumah Sakit"
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 15),
                                                      const Text(
                                                        "Jam Buka",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        item.data()['jamBuka'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18),
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      const Text(
                                                        "Jam Tutup",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        item.data()['jamTutup'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18),
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      const Text(
                                                        "Poli",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        item.data()[
                                                            'poliklinik'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(height: 15),
                                            const Text(
                                              "Alamat",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              item.data()['address'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                            ButtonWidget(
                                                height: 40,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Tutup"))
                                          ],
                                        )
                                      ]),
                                    );
                                  });
                            },
                          )
                    },
                    onMapCreated: _onMapCreated,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          //     child: SafeArea(
          //       child: TextField(
          //         onSubmitted: (value) {},
          //         onTap: () {},
          //         decoration: InputDecoration(
          //           contentPadding: const EdgeInsets.symmetric(vertical: 12),
          //           filled: true,
          //           fillColor: Colors.white,
          //           hintText: "Cari Layanan",
          //           prefixIcon: const Icon(Icons.search),
          //           border: OutlineInputBorder(
          //             borderSide: BorderSide(
          //               color: Colors.grey.shade300,
          //             ),
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //           enabledBorder: OutlineInputBorder(
          //             borderSide: BorderSide(
          //               color: Colors.grey.shade300,
          //             ),
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _currentIndex == 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pengaduan / Laporan",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                maxLines: 6, //or null
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Masukkan keluhan Anda",
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
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const ButtonWidget(
                                height: 40,
                                child: Text("Ajukan Pengaduan"),
                              )
                            ],
                          ),
                        ))
                    : const SizedBox(),
                SizedBox(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: ClipPath(
                        clipper: const ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                    topRight: Radius.circular(40),
                                    topLeft: Radius.circular(40)))),
                        child: BottomNavigationBar(
                          backgroundColor: Colors.white,
                          items: const <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              icon: Icon(Icons.home),
                              label: 'Layanan',
                            ),
                            // BottomNavigationBarItem(
                            //   icon: Icon(Icons.call),
                            //   label: 'Call',
                            // ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.filter_alt),
                              label: 'Filter',
                            ),
                          ],
                          currentIndex: _currentIndex,
                          // selectedItemColor: Colors.amber[800],
                          onTap: (index) {
                            if (index == 0) {
                              setState(() {
                                _currentIndex = index;
                              });
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return FilterWidget(
                                      selected: jenisLayanan,
                                      onPressed: (jenis) {
                                        setState(() {
                                          jenisLayanan = jenis;
                                          filtereds = [];
                                        });

                                        var filtered = [];
                                        for (var item in locations) {
                                          if (item.data()["type"] == jenis) {
                                            filtered.add(item);
                                            filtereds.add(item.id);
                                          }
                                        }

                                        if (filtered.isEmpty) {
                                          filtered = locations;
                                        }

                                        mapController?.moveCamera(
                                          CameraUpdate.newLatLngZoom(
                                            LatLng(
                                                filtered[0]
                                                    .data()['location']
                                                    .latitude,
                                                filtered[0]
                                                    .data()['location']
                                                    .longitude),
                                            jenis == "" ? 13 : 18.0,
                                          ),
                                        );
                                      },
                                    );
                                  });
                            }
                          },
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _getServices() async {
    var db = await FirebaseFirestore.instance.collection("services").get();

    return db.docs;
  }

  void _onMapCreated(GoogleMapController controller) {
    print("sds");
    mapController = controller;
  }
}
