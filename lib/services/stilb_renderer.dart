import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Motor de Renderizacao STILB (Ignora PDFium)
class StilbRenderer extends StatelessWidget {
  final Uint8List pdfBytes;
  const StilbRenderer({super.key, required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    // O flutter_pdf usa o motor nativo do Flutter (Skia/Impeller) em vez do C++
    return PdfPreview(
      build: (format) => pdfBytes,
      canChangePageFormat: false,
      canDebug: false,
    );
  }
}