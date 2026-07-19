import 'package:flutter/material.dart';

/// Box shadow tokens ported from `--ig-shadow-*`.
abstract final class IgShadows {
  static const sm = [
    BoxShadow(color: Color(0x0F101828), offset: Offset(0, 1), blurRadius: 2),
  ];

  static const md = [
    BoxShadow(color: Color(0x14101828), offset: Offset(0, 2), blurRadius: 8),
    BoxShadow(color: Color(0x0F101828), offset: Offset(0, 1), blurRadius: 2),
  ];

  static const lg = [
    BoxShadow(color: Color(0x29101828), offset: Offset(0, 12), blurRadius: 32),
    BoxShadow(color: Color(0x14101828), offset: Offset(0, 2), blurRadius: 8),
  ];
}
