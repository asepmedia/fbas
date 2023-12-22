import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latihan_fbase/pages/login_page.dart';
import 'package:latihan_fbase/widgets/button_widget.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _isCreate = false;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.242638190510166, 106.84342457481368),
    zoom: 19.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  void toggleIsCreate() {
    setState(() {
      _isCreate = !_isCreate;
    });
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
            GoogleMap(
              mapType: MapType.terrain,
              trafficEnabled: true,
              initialCameraPosition: _kGooglePlex,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(
                <Marker>[
                  Marker(
                    draggable: true,
                    markerId: MarkerId("1"),
                    position: LatLng(-6.242638190510166, 106.84342457481368),
                    icon: BitmapDescriptor.defaultMarker,
                    infoWindow: const InfoWindow(
                      title: 'Drag',
                    ),
                    onDragEnd: (value) {
                      print(value);
                    },
                  )
                ],
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
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
                                "Tambah Layanan",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Silakan drag & drop marker pada map untuk menentukan lokasi",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(color: Colors.green.shade900),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InputWidget(),
                              const SizedBox(
                                height: 20,
                              ),
                              const ButtonWidget(
                                height: 40,
                                child: Text("Tambah Lokasi"),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) {},
      onTap: () {},
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        filled: true,
        fillColor: Colors.white,
        hintText: "Nama Layanan",
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
    );
  }
}
