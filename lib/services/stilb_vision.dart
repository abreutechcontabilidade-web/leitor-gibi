// STILB VISION - Espadachim v1 (PF-309)
// 100% Dart puro, deterministico. Sem LLM, sem C++, sem rede.
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;

class StilbVision {
  static List<Rect> detectInkBands(Uint8List bytes, {int maxSide = 900}) {
    final full = img.decodeImage(bytes);
    if (full == null) return [];
    img.Image work = full;
    if (full.width > maxSide) {
      final nh = (full.height * maxSide / full.width).round();
      work = img.copyResize(full, width: maxSide, height: nh);
    }
    final gray = img.grayscale(work);
    final int t = _otsu(gray);
    final int w = gray.width;
    final int h = gray.height;

    // Projecao de linhas: densidade de pixels escuros por linha
    final rowDark = List<int>.filled(h, 0);
    for (int y = 0; y < h; y++) {
      int count = 0;
      for (int x = 0; x < w; x++) {
        if (gray.getPixel(x, y).r < t) count++;
      }
      rowDark[y] = count;
    }

    // Bandas: linhas contiguas com densidade acima do corte (4%)
    final int minDensity = (w * 0.04).round();
    final bands = <List<int>>[];
    int start = -1;
    for (int y = 0; y < h; y++) {
      if (rowDark[y] >= minDensity) {
        if (start == -1) start = y;
      } else if (start != -1) {
        bands.add([start, y]);
        start = -1;
      }
    }
    if (start != -1) bands.add([start, h]);

    // Altura plausivel de texto + envelope horizontal por banda
    final int minH = (h * 0.008).round();
    final int maxH = (h * 0.20).round();
    final double kx = w > 0 ? full.width / w : 1.0;
    final double ky = h > 0 ? full.height / h : 1.0;
    final rects = <Rect>[];
    for (final band in bands) {
      final int bh = band[1] - band[0];
      if (bh < minH || bh > maxH) continue;
      int minX = w, maxX = -1;
      for (int y = band[0]; y < band[1]; y++) {
        for (int x = 0; x < w; x++) {
          if (gray.getPixel(x, y).r < t) {
            if (x < minX) minX = x;
            if (x > maxX) maxX = x;
          }
        }
      }
      if (maxX <= minX) continue;
      rects.add(Rect.fromLTWH(minX * kx, band[0] * ky, (maxX - minX) * kx, bh * ky));
    }
    return rects;
  }

  static int _otsu(img.Image gray) {
    final histogram = List<int>.filled(256, 0);
    for (int y = 0; y < gray.height; y++) {
      for (int x = 0; x < gray.width; x++) {
        int v = gray.getPixel(x, y).r.toInt();
        if (v < 0) v = 0;
        if (v > 255) v = 255;
        histogram[v]++;
      }
    }
    final int total = gray.width * gray.height;
    double sum = 0;
    for (int i = 0; i < 256; i++) {
      sum += i * histogram[i];
    }
    double sumB = 0;
    int wB = 0;
    double best = 0;
    int threshold = 127;
    for (int t = 0; t < 256; t++) {
      wB += histogram[t];
      if (wB == 0) continue;
      final int wF = total - wB;
      if (wF == 0) break;
      sumB += t * histogram[t];
      final double mB = sumB / wB;
      final double mF = (sum - sumB) / wF;
      final double variance = wB * wF * (mB - mF) * (mB - mF);
      if (variance > best) {
        best = variance;
        threshold = t;
      }
    }
    return threshold;
  }
}