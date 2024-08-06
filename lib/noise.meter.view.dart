import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:screamtowin/assets/index.dart';
import 'package:screamtowin/constant.dart';
import 'package:screamtowin/models/setting.model.dart';
import 'package:screamtowin/popup_setting.dart';
import 'package:screamtowin/utils.dart';
import 'package:screamtowin/widgets/index.dart';

import 'noise.meter.dart';
import 'widgets/popup/pop_up.dart';

class NoiseMeterView extends StatefulWidget {
  const NoiseMeterView({super.key});

  @override
  State<NoiseMeterView> createState() => _NoiseMeterViewState();
}

class _NoiseMeterViewState extends State<NoiseMeterView> {
  final record = AudioRecorder();
  Stream<Uint8List>? audioStream;
  SettingModel setting = SettingModel();
  int decibel = 0;
  bool win = false;

  @override
  void initState() {
    super.initState();
    handlerRefreshSetting();
  }

  @override
  void dispose() {
    record.stop();
    super.dispose();
  }

  void handlerRefreshSetting() {
    readStorage(
        key: "setting",
        cb: (value) {
          if (value != null) {
            setting = SettingModel.fromJson(jsonDecode(value));
          } else {
            writeStorage(
                key: "setting", value: jsonEncode(SettingModel().toJson()));
          }
          setState(() {});
        });
  }

  void listenScream() async {
    if (await record.hasPermission()) {
      audioStream = await record
          .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
      audioStream!.listen((data) {
        decibel = calculateDecibels(data);
        if (calculateScore(decibel) == 100) {
          record.stop();
          audioStream = null;
          win = true;
        }
        setState(() {});
      });
    }
  }

  // Views

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TouchableOpacity(
        activeOpacity: 1,
        onPress: () {
          if (win) {
            win = false;
          } else {
            if (audioStream != null) {
              record.stop();
              audioStream = null;
            } else {
              listenScream();
            }
          }
          setState(() {});
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: setting.backgroundColor,
          child: Stack(
            children: [
              if (setting.backgroundImage.isNotEmpty)
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  // child: Image.asset(appImages["IMG_BACKGROUND"]!),
                  child: Image.file(File(setting.backgroundImage),
                      fit: BoxFit.cover),
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (setting.headerImage.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: setting.headerImageHeight,
                              width: setting.headerImageWidth,
                              // child: Image.asset(appImages["IMG_HEADER"]!),
                              child: Image.file(File(setting.headerImage),
                                  fit: BoxFit.contain),
                            ),
                          ],
                        ),
                      ],
                    ),
                  Expanded(
                      child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!win)
                          OutlinedText(
                              text: setting.headerText,
                              fontSize: 24,
                              outlineColor: Colors.white,
                              textColor: const Color(0xFFF56A41)),
                        const SizedBox(height: 18),
                        OutlinedText(
                            text: win
                                ? setting.headerTextWin
                                : setting.headerSubText,
                            fontSize: 52,
                            outlineColor: Colors.white,
                            textColor: primaryGreen),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          child: OutlinedText(
                              text: (audioStream == null && !win)
                                  ? "-"
                                  : "${calculateScore(decibel)}",
                              fontSize: 120,
                              outlineColor: Colors.white,
                              textColor: const Color(0xFF0C3F72)),
                        ),
                        if (!win && setting.bottomImage.isNotEmpty)
                          SizedBox(
                            height: setting.bottomImageHeight,
                            width: setting.bottomImageWidth,
                            child: Image.file(
                              File(setting.bottomImage),
                              fit: BoxFit.contain,
                            ),
                          ),
                        if (win && setting.bottomImageWin.isNotEmpty)
                          SizedBox(
                            height: setting.bottomImageHeight,
                            width: setting.bottomImageWidth,
                            child: Image.file(
                              File(setting.bottomImageWin),
                              fit: BoxFit.contain,
                            ),
                          ),
                        // SizedBox(
                        //   height: setting.bottomImageHeight,
                        //   width: setting.bottomImageWidth,
                        //   child: Image.asset(appImages[win ? "IMG_GLOBE_2" : "IMG_GLOBE"]!),
                        // ),
                      ],
                    ),
                  )),
                  if (setting.footerImage.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 24, top: 8),
                              height: setting.footerImageHeight,
                              width: setting.footerImageWidth,
                              // child: Image.asset(appImages["IMG_FOOTER"]!),
                              child: Image.file(
                                File(setting.footerImage),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
              Positioned(
                  bottom: 12,
                  right: 12,
                  child: TouchableOpacity(
                      onPress: () {},
                      child: PopUp(
                        tag: 'setting',
                        padding: const EdgeInsets.all(0),
                        popUp: PopUpItem(
                          padding: const EdgeInsets.all(24),
                          color: const Color.fromARGB(255, 38, 48, 65),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          tag: 'setting',
                          child: PopUpSetting(
                            refresh: handlerRefreshSetting,
                          ),
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: Color.fromARGB(135, 255, 255, 255),
                          size: 24,
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
