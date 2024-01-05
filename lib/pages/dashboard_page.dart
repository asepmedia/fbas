import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latihan_fbase/widgets/button_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.242638190510166, 106.84342457481368),
    zoom: 20.4746,
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
      body: Stack(
        children: [
          FutureBuilder(
              future: _getServices(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data
                      as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
                  return GoogleMap(
                    mapType: MapType.terrain,
                    trafficEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    zoomControlsEnabled: false,
                    markers: {
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
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
                        )
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: SafeArea(
                child: TextField(
                  onSubmitted: (value) {},
                  onTap: () {},
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Cari Layanan",
                    prefixIcon: const Icon(Icons.search),
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
              ),
            ),
          ),
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
                              icon: Icon(Icons.star),
                              label: 'Favorit',
                            ),
                          ],
                          currentIndex: _currentIndex,
                          // selectedItemColor: Colors.amber[800],
                          onTap: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
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
}
