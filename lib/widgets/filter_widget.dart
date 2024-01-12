import 'package:flutter/material.dart';
import 'package:latihan_fbase/pages/admin/admin_dashboard_page.dart';
import 'package:latihan_fbase/widgets/button_widget.dart';

class FilterWidget extends StatefulWidget {
  final Function(String jenis) onPressed;
  final String selected;
  const FilterWidget(
      {super.key, required this.onPressed, required this.selected});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String jenisLayanan = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter Layanan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Text(
            "Pilih layanan yang ingin Anda lihat",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
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
          const SizedBox(height: 30),
          InkWell(
            onTap: () {
              setState(() {
                jenisLayanan = "";
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Reset",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500))
              ],
            ),
          ),
          const SizedBox(height: 10),
          ButtonWidget(
              height: 35,
              onPressed: () {
                widget.onPressed(jenisLayanan);
                Navigator.pop(context);
              },
              child: const Text("Simpan"))
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      jenisLayanan = widget.selected;
    });
    super.initState();
  }
}
