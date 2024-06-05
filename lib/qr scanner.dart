import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

const bgColor = Color(0xfffafafa);

class qr extends StatefulWidget {
  const qr({super.key});

  @override
  State<qr> createState() => _qrState();
}

class _qrState extends State<qr> {
  bool isscancomplete = false;
  bool isflashon = false;
  bool isfrontcamera = false;
  MobileScannerController controller = MobileScannerController();

  void closescreen() {
    isscancomplete = false;
  }

  Future<void> addscannedDataToFirestore(String scannedData) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('scanned');
    try {
      await reference.add({
        'data': scannedData,
      });
    } catch (e) {
      print("::::::::::::::::: $e  ;;;;;;;;;;;");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: const Drawer(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isflashon = !isflashon;
                });
                if (isflashon) {
                  controller.toggleTorch();
                }
              },
              icon: Icon(
                Icons.flash_on,
                color: isflashon ? Colors.blue : Colors.grey,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  isfrontcamera = !isfrontcamera;
                });
                controller.switchCamera();
              },
              icon: Icon(
                Icons.camera_front,
                color: isfrontcamera ? Colors.blue : Colors.grey,
              ))
        ],
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "QR Scanner",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR code here",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Scan will be done automatically",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  )
                ],
              ),
            )),
            Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    MobileScanner(
                      onDetect: (BarcodeCapture capture) {
                        if (!isscancomplete) {
                          final List<Barcode> barcodes = capture.barcodes;
                          for (final barcode in barcodes) {
                            final String? code = barcode.rawValue ?? null;
                            if (code != null) {
                              setState(() {
                                isscancomplete = true;
                              });
                            }
                            addscannedDataToFirestore(code.toString());
                            print(code.toString());
                            Navigator.pop(context);
                          }
                        }
                      },
                      controller: controller,
                    ),
                    QRScannerOverlay(
                      overlayColor: bgColor,
                    )
                  ],
                )),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Developed by",
                style: TextStyle(
                    fontSize: 14, color: Colors.black87, letterSpacing: 1),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
