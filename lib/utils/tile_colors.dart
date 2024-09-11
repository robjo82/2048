import 'package:flutter/material.dart';

Color colorForValue(int value) {
  switch (value) {
    case 0:
      return const Color(0xFFFCF7FF);
    case 2:
      return const Color(0xFFFDC3CA);
    case 4:
      return const Color(0xFFFE8E94);
    case 8:
      return const Color(0xFFFF5A5F);
    case 16:
      return const Color(0xFFFE7284);
    case 32:
      return const Color(0xFFFC8AA9);
    case 64:
      return const Color(0xFFFBA1CD);
    case 128:
      return const Color(0xFFF9B9F2);
    case 256:
      return const Color(0xFFF6BEC3);
    case 512:
      return const Color(0xFFF5C0AB);
    case 1024:
      return const Color(0xFFF3C394);
    case 2048:
      return const Color(0xFFF2C57C);
    case 4096:
      return const Color(0xFFD0A782);
    case 8192:
      return const Color(0xFFAE8988);
    case 16384:
      return const Color(0xFF8C6A8D);
    case 32768:
      return const Color(0xFF6A4C93);
    case 65536:
      return const Color(0xFF495494);
    default:
      return const Color(0xFF495494);
  }
}
