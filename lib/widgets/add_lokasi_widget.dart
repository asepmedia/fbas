import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_fbase/widgets/button_widget.dart';

class AddLokasiWidget extends StatefulWidget {
  LatLng selectedLocation;
  AddLokasiWidget({super.key, required this.selectedLocation});

  @override
  State<AddLokasiWidget> createState() => _AddLokasiWidgetState();
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

class _AddLokasiWidgetState extends State<AddLokasiWidget> {
  final TextEditingController _serviceNameC = TextEditingController();

  final TextEditingController _addressC = TextEditingController();
  final TextEditingController _jamBuka = TextEditingController();
  final TextEditingController _jamTutup = TextEditingController();
  final TextEditingController _poliklinik = TextEditingController();

  late dynamic _selectedAddress;
  String jenisLayanan = "Rumah Sakit";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tambah Layanan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Silakan drag & drop marker pada map untuk menentukan lokasi",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green.shade900),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InputWidget(
                label: "Nama Layanan",
                controller: _serviceNameC,
              ),
              const SizedBox(
                height: 15,
              ),
              InputWidget(
                label: "Alamat",
                maxLines: 2,
                controller: _addressC,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Jenis Layanan",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        jenisLayanan = "Rumah Sakit";
                      });
                    },
                    child: BadgeWidget(
                      label: "Rumah Sakit",
                      isActive: jenisLayanan == "Rumah Sakit",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        jenisLayanan = "Layanan Publik";
                      });
                      print("ADA");
                    },
                    child: BadgeWidget(
                      label: "Layanan Publik",
                      isActive: jenisLayanan == "Layanan Publik",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InputWidget(
                label: "Jam Buka",
                controller: _jamBuka,
              ),
              const SizedBox(
                height: 15,
              ),
              InputWidget(
                label: "Jam Tutup",
                controller: _jamTutup,
              ),
              const SizedBox(
                height: 15,
              ),
              if (jenisLayanan == "Rumah Sakit")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputWidget(
                      label: "Poliklinik",
                      controller: _poliklinik,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Latitude: ${widget.selectedLocation.latitude}"),
                  Text("Longitude: ${widget.selectedLocation.longitude}")
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                height: 40,
                child: const Text("Tambah Lokasi"),
                onPressed: () async {
                  var db = FirebaseFirestore.instance;
                  db.collection("services").add({
                    "name": _serviceNameC.text,
                    "address": _addressC.text,
                    "type": jenisLayanan,
                    "jamBuka": _jamBuka.text,
                    "jamTutup": _jamTutup.text,
                    "poliklinik": _poliklinik.text,
                    "location": GeoPoint(widget.selectedLocation.latitude,
                        widget.selectedLocation.longitude)
                  });
                  showLoginAlertMsg("Sukses", "Lokasi berhasil ditambahkan");
                },
              )
            ],
          )
        ],
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
    // TODO: implement initState
    getAddressByCoordinate(widget.selectedLocation);
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
}
