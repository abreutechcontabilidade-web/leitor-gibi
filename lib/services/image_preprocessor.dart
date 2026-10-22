import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;

class ImagePreprocessor {
  static Float32List toNchwTensor(Uint8List bytes,
      {int w = 640, int h = 640, bool minus1to1 = true}) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw Exception('Decode falhou');
    final res = img.copyResize(decoded, width: w, height: h);
    final t = Float32List(3 * h * w);
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        final p = res.getPixel(x, y);
        double r = p.r.toDouble(), g = p.g.toDouble(), b = p.b.toDouble();
        if (minus1to1) { r = r / 127.5 - 1; g = g / 127.5 - 1; b = b / 127.5 - 1; }
        else { r /= 255; g /= 255; b /= 255; }
        final o = y * w + x;
        t[o] = r; t[h * w + o] = g; t[2 * h * w + o] = b;
      }
    }
    return t;
  }

  static String dominantColorName(Uint8List bytes, Rect box) {
    final dec = img.decodeImage(bytes);
    if (dec == null) return 'unknown';
    int rs = 0, gs = 0, bs = 0, n = 0;
    final x0 = box.left.toInt().clamp(0, dec.width - 1);
    final y0 = box.top.toInt().clamp(0, dec.height - 1);
    final x1 = box.right.toInt().clamp(0, dec.width);
    final y1 = box.bottom.toInt().clamp(0, dec.height);
    for (int y = y0; y < y1; y += 4) {
      for (int x = x0; x < x1; x += 4) {
        final p = dec.getPixel(x, y);
        rs += p.r.toInt(); gs += p.g.toInt(); bs += p.b.toInt(); n++;
      }
    }
    if (n == 0) return 'unknown';
    final r = rs / n, g = gs / n, b = bs / n;
    if (r > 150 && r > g && r > b) return 'red';
    if (g > 120 && g > r && g > b) return 'green';
    if (b > 120 && b > r && b > g) return 'blue';
    if (r > 180 && g > 180 && b > 180) return 'white';
    if (r < 60 && g < 60 && b < 60) return 'black';
    return 'mixed';
  }
}
