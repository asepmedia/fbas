import 'dart:async';

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
    zoom: 40.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            trafficEnabled: true,
            initialCameraPosition: _kGooglePlex,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
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
                              label: 'Home',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.call),
                              label: 'Call',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.star),
                              label: 'Favorite',
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
}
