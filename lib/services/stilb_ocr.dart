import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;

class StilbOCR {
  static List<Rect> detectBubbles(Uint8List bytes) {
    final image = img.decodeImage(bytes);
    if (image == null) return [];

    final gray = img.grayscale(image);
    int threshold = _otsuThreshold(gray);
    
    List<Rect> regions = [];
    int startY = -1;
    
    for (int y = 0; y < gray.height; y++) {
      int darkPixels = 0;
      for (int x = 0; x < gray.width; x++) {
        if (gray.getPixel(x, y).r < threshold) darkPixels++;
      }
      
      if (darkPixels > (gray.width * 0.05)) {
        if (startY == -1) startY = y;
      } else {
        if (startY != -1) {
          int h = y - startY;
          if (h > 15 && h < 200) {
            regions.add(Rect.fromLTWH(20, startY.toDouble(), gray.width - 40.0, h.toDouble()));
          }
          startY = -1;
        }
      }
    }
    return regions;
  }

  static int _otsuThreshold(img.Image gray) {
    List<int> histogram = List.filled(256, 0);
    for (int y = 0; y < gray.height; y++) {
      for (int x = 0; x < gray.width; x++) {
        histogram[gray.getPixel(x, y).r.toInt()]++;
      }
    }
    int total = gray.width * gray.height;
    double sum = 0;
    for (int i = 0; i < 256; i++) sum += i * histogram[i];
    double sumB = 0, wB = 0, maxVariance = 0;
    int threshold = 0;
    for (int t = 0; t < 256; t++) {
      wB += histogram[t];
      if (wB == 0) continue;
      double wF = total - wB;
      if (wF == 0) break;
      sumB += t * histogram[t];
      double mB = sumB / wB;
      double mF = (sum - sumB) / wF;
      double variance = wB * wF * pow(mB - mF, 2);
      if (variance > maxVariance) {
        maxVariance = variance;
        threshold = t;
      }
    }
    return threshold;
  }
}