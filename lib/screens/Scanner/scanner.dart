import 'dart:io';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart'; // Import the new package
import 'package:blockchain_upi/screens/Payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String code = "";
  final ImagePicker picker = ImagePicker();

  Future<String?> loadImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildQrView(context),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return AiBarcodeScanner(
      controller: MobileScannerController(),
      hideSheetDragHandler: true,
      hideSheetTitle: true,
      cutOutSize: 250,
      onDetect: (p0) {
        print("eegegegegegegegegegegegeg");
        print(p0.raw.toString());

        for (int i = 0; i < 10; i++) {
          print("${i + 1} : 1o1jij1j1iji1jijijij");
        }
        final String? scannedValue = p0.barcodes.first.rawValue;

        for (int i = 0; i < p0.barcodes.length; i++) {
          print("$i == +++ ${p0.barcodes[i].rawValue}");
        }
        print(scannedValue);

        for (int i = 0; i < 10; i++) {
          print("${i + 1} : $scannedValue");
        }
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              receiverAddress: scannedValue!,
            ),
          ),
        );
      },
    );
  }
}
