import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle light16P({Color? color}) => GoogleFonts.poppins().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: color,
      );

  static TextStyle bold16NS({Color? color}) => GoogleFonts.notoSans().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle bold14NS({Color? color}) => GoogleFonts.notoSans().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle regular14NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle semiBold16NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle medium16NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle regular16NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle semiBold14NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle medium14NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle medium12NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle regular10NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle medium10NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle regular12NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle medium20NS({Color? color}) =>
      GoogleFonts.notoSans().copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color,
      );
}
