import 'package:flutter/material.dart';
import 'package:screamtowin/constant.dart';

class SettingModel {
  Color backgroundColor;
  String backgroundImage;
  String headerImage;
  double headerImageHeight;
  double headerImageWidth;
  String headerText;
  double headerTextFontSize;
  Color headerTextColor;
  String headerTextWin;
  String headerSubText;
  Color headerSubTextColor;
  double headerSubTextFontSize;
  String bottomImage;
  String bottomImageWin;
  String bottomImageLose;
  double bottomImageHeight;
  double bottomImageWidth;
  String footerImage;
  double footerImageWidth;
  double footerImageHeight;
  Color scoreColor;
  double scoreFontSize;
  double sensitivity;
  int duration;

  bool useBarImage;
  String barImage20;
  String barImage40;
  String barImage60;
  String barImage80;
  String barImage100;
  double barImageHeight;
  double barImageWidth;

  SettingModel({
    this.backgroundColor = const Color(0xFFC4D23F),
    this.backgroundImage = "",
    this.headerImageHeight = 160,
    this.headerImageWidth = 450,
    this.headerImage = "",
    this.headerText = "TERIAKIN:",
    this.headerTextWin = "SKOR KAMU:",
    this.headerTextFontSize = 24,
    this.headerTextColor = const Color(0xFFF56A41),
    this.headerSubText = "AKU SIAP\nSADAR\nLINGKUNGAN",
    this.headerSubTextColor = primaryGreen,
    this.headerSubTextFontSize = 52,
    this.bottomImage = "",
    this.bottomImageWin = "",
    this.bottomImageLose = "",
    this.bottomImageHeight = 540,
    this.bottomImageWidth = 540,
    this.footerImage = "",
    this.footerImageHeight = 60,
    this.footerImageWidth = 450,
    this.scoreColor = const Color(0xFF0C3F72),
    this.scoreFontSize = 120,
    this.sensitivity = 75.0,
    this.duration = 8,
    this.useBarImage = false,
    this.barImage20 = "",
    this.barImage40 = "",
    this.barImage60 = "",
    this.barImage80 = "",
    this.barImage100 = "",
    this.barImageHeight = 300,
    this.barImageWidth = 300,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      backgroundColor: Color(int.parse(
              json['backgroundColor'].toString().substring(1),
              radix: 16) +
          0xFF000000),
      backgroundImage: json['backgroundImage'],
      headerImageHeight: json['headerImageHeight'],
      headerImageWidth: json['headerImageWidth'],
      headerImage: json['headerImage'],
      headerText: json['headerText'],
      headerTextWin: json['headerTextWin'],
      headerTextFontSize: json['headerTextFontSize'],
      headerTextColor: Color(int.parse(
              json['headerTextColor'].toString().substring(1),
              radix: 16) +
          0xFF000000),
      headerSubText: json['headerSubText'],
      headerSubTextColor: Color(int.parse(
              json['headerSubTextColor'].toString().substring(1),
              radix: 16) +
          0xFF000000),
      headerSubTextFontSize: json['headerSubTextFontSize'],
      bottomImage: json['bottomImage'],
      bottomImageWin: json['bottomImageWin'],
      bottomImageLose: json['bottomImageLose'] ?? "",
      bottomImageHeight: json['bottomImageHeight'],
      bottomImageWidth: json['bottomImageWidth'],
      footerImage: json['footerImage'],
      footerImageHeight: json['footerImageHeight'],
      footerImageWidth: json['footerImageWidth'],
      scoreColor: Color(
          int.parse(json['scoreColor'].toString().substring(1), radix: 16) +
              0xFF000000),
      scoreFontSize: json['scoreFontSize'],
      sensitivity: json['sensitivity'] ?? 75.0,
      duration: json['duration'] ?? 8,
      useBarImage: json['useBarImage'] ?? false,
      barImage20: json['barImage20'] ?? "",
      barImage40: json['barImage40'] ?? "",
      barImage60: json['barImage60'] ?? "",
      barImage80: json['barImage80'] ?? "",
      barImage100: json['barImage100'] ?? "",
      barImageHeight: json['barImageHeight'] ?? 300,
      barImageWidth: json['barImageWidth'] ?? 300,
    );
  }

  toJson() {
    return {
      'backgroundColor': '#${backgroundColor.value.toRadixString(16)}',
      'backgroundImage': backgroundImage,
      'headerImageHeight': headerImageHeight,
      'headerImageWidth': headerImageWidth,
      'headerImage': headerImage,
      'headerText': headerText,
      'headerTextWin': headerTextWin,
      'headerTextFontSize': headerTextFontSize,
      'headerTextColor': '#${headerTextColor.value.toRadixString(16)}',
      'headerSubText': headerSubText,
      'headerSubTextColor': '#${headerSubTextColor.value.toRadixString(16)}',
      'headerSubTextFontSize': headerSubTextFontSize,
      'bottomImage': bottomImage,
      'bottomImageWin': bottomImageWin,
      'bottomImageLose': bottomImageLose,
      'bottomImageHeight': bottomImageHeight,
      'bottomImageWidth': bottomImageWidth,
      'footerImage': footerImage,
      'footerImageHeight': footerImageHeight,
      'footerImageWidth': footerImageWidth,
      'scoreColor': '#${scoreColor.value.toRadixString(16)}',
      'scoreFontSize': scoreFontSize,
      'sensitivity': sensitivity,
      'duration': duration,
      'useBarImage': useBarImage,
      'barImage20': barImage20,
      'barImage40': barImage40,
      'barImage60': barImage60,
      'barImage80': barImage80,
      'barImage100': barImage100,
      'barImageHeight': barImageHeight,
      'barImageWidth': barImageWidth,
    };
  }
}
