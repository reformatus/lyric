import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Shows a fullscreen QR code dialog
///
/// [data] - The data to encode in the QR code
/// [title] - The title displayed at the top
Future<void> showFullscreenQrDialog(
  BuildContext context, {
  required String data,
  required String title,
}) async {
  return showDialog<void>(
    context: context,
    builder: (context) => FullscreenQrDialog(data: data, title: title),
  );
}

class FullscreenQrDialog extends StatelessWidget {
  const FullscreenQrDialog({
    required this.data,
    required this.title,
    super.key,
  });

  final String data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: Text(title),
      ),
      body: Center(
        child: Hero(
          tag: 'ShareDialogQr',
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: QrImageView(
              data: data,
              version: QrVersions.auto,
              gapless: true,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
