import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FullscreenQrDialog extends StatelessWidget {
  const FullscreenQrDialog({required this.data, super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.pop,
      child: Hero(
        tag: 'ShareDialogQr',
        child: Container(
          color: Colors.white,
          child: Center(
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
      ),
    );
  }
}
