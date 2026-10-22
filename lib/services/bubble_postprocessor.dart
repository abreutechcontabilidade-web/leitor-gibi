import 'dart:ui';

class BubblePostprocessor {
  static List<Rect> decodeYolo(List? output, {double conf = 0.35}) {
    if (output == null || output.isEmpty) return [];
    final dets = output[0] as List?;
    if (dets == null) return [];
    final res = <Rect>[];
    for (final d in dets) {
      if (d is! List || d.length < 5) continue;
      final c = (d[4] as num).toDouble();
      if (c < conf) continue;
      final cx = (d[0] as num).toDouble(), cy = (d[1] as num).toDouble();
      final w = (d[2] as num).toDouble(), h = (d[3] as num).toDouble();
      res.add(Rect.fromLTWH(cx - w / 2, cy - h / 2, w, h));
    }
    return nms(res);
  }

  static List<Rect> nms(List<Rect> boxes, {double iouT = 0.45}) {
    final sorted = List<Rect>.from(boxes);
    final keep = <Rect>[];
    while (sorted.isNotEmpty) {
      final best = sorted.removeAt(0);
      keep.add(best);
      sorted.removeWhere((b) => iou(best, b) > iouT);
    }
    return keep;
  }

  static double iou(Rect a, Rect b) {
    final i = a.intersect(b);
    if (i.width <= 0 || i.height <= 0) return 0;
    final ia = i.width * i.height;
    final u = a.width * a.height + b.width * b.height - ia;
    return u <= 0 ? 0 : ia / u;
  }
}
