import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:screamtowin/assets/index.dart';
import 'package:screamtowin/constant.dart';
import 'package:screamtowin/models/setting.model.dart';
import 'package:screamtowin/popup_setting.dart';
import 'package:screamtowin/utils.dart';
import 'package:screamtowin/widgets/index.dart';
import 'package:window_manager/window_manager.dart';

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
  int highScore = 0;
  bool win = false;
  Timer? timeId;
  bool isFullscreen = false;
  late ConfettiController _controllerTopCenter;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    handlerRefreshSetting();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    super.dispose();
    record.stop();
    player.dispose();
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
        decibel = calculateDecibels(data, sensitivity: setting.sensitivity);
        var score = calculateScore(decibel);
        if (score > highScore) highScore = score;
        setState(() {});
      });

      // Set timer
      timeId = Timer(Duration(seconds: setting.duration), () async {
        _controllerTopCenter.play();
        setState(() {
          record.stop();
          audioStream = null;
          win = true;
          timeId?.cancel();
          timeId = null;
        });
        await player.play(AssetSource(appAudios["AUDIO_WIN"]!),
            volume: 5, mode: PlayerMode.lowLatency);
      });
    }
  }

  // Views

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TouchableOpacity(
        activeOpacity: 1,
        onPress: () async {
          if (win) {
            win = false;
            highScore = 0;
            decibel = 0;
            _controllerTopCenter.stop();
            await player.stop();
          } else {
            setState(() {
              timeId?.cancel();
              timeId = null;
            });
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
                    child: Image.file(File(setting.backgroundImage),
                        fit: BoxFit.cover)
                    // child: setting.backgroundImage.isNotEmpty
                    //     ? Image.file(File(setting.backgroundImage),
                    //         fit: BoxFit.cover)
                    //     : Image.asset(appImages["IMG_BACKGROUND"]!),
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
                                child: Image.file(File(setting.headerImage),
                                    fit: BoxFit.contain)
                                // child: setting.headerImage.isNotEmpty
                                //     ? Image.file(File(setting.headerImage),
                                //         fit: BoxFit.contain)
                                //     : Image.asset(appImages["IMG_HEADER"]!),
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
                                  : win
                                      ? "$highScore"
                                      : "${calculateScore(decibel)}",
                              fontSize: 120,
                              outlineColor: Colors.white,
                              textColor: const Color(0xFF0C3F72)),
                        ),
                        if (setting.useBarImage)
                          ShakingWidget(
                              child: Container(
                            margin: const EdgeInsets.only(top: 60),
                            height: setting.barImageHeight,
                            width: setting.barImageWidth,
                            child: Stack(
                              children: [
                                Opacity(
                                  opacity: .3,
                                  child: Image.file(File(setting.barImage100),
                                      fit: BoxFit.contain),
                                ),
                                Opacity(
                                  opacity: (win
                                          ? (highScore >= 10)
                                          : (calculateScore(decibel) >= 10))
                                      ? 1
                                      : 0,
                                  child: Image.file(File(setting.barImage20),
                                      fit: BoxFit.contain),
                                ),
                                Opacity(
                                  opacity: (win
                                          ? (highScore >= 30)
                                          : (calculateScore(decibel) >= 40))
                                      ? 1
                                      : 0,
                                  child: Image.file(File(setting.barImage40),
                                      fit: BoxFit.contain),
                                ),
                                Opacity(
                                  opacity: (win
                                          ? (highScore >= 50)
                                          : (calculateScore(decibel) >= 60))
                                      ? 1
                                      : 0,
                                  child: Image.file(File(setting.barImage60),
                                      fit: BoxFit.contain),
                                ),
                                Opacity(
                                  opacity: (win
                                          ? (highScore >= 70)
                                          : (calculateScore(decibel) >= 80))
                                      ? 1
                                      : 0,
                                  child: Image.file(File(setting.barImage80),
                                      fit: BoxFit.contain),
                                ),
                                Opacity(
                                  opacity: (win
                                          ? (highScore >= 90)
                                          : (calculateScore(decibel) >= 95))
                                      ? 1
                                      : 0,
                                  child: Image.file(File(setting.barImage100),
                                      fit: BoxFit.contain),
                                ),
                              ],
                            ),
                          )),
                        if (!win &&
                            !setting.useBarImage &&
                            setting.bottomImage.isNotEmpty)
                          ShakingWidget(
                              child: SizedBox(
                            height: setting.bottomImageHeight,
                            width: setting.bottomImageWidth,
                            child: setting.bottomImage.isNotEmpty
                                ? Image.file(
                                    File(setting.bottomImage),
                                    fit: BoxFit.contain,
                                  )
                                : Image.asset(appImages["IMG_GLOBE"]!),
                          )),
                        if (win &&
                            !setting.useBarImage &&
                            setting.bottomImageWin.isNotEmpty)
                          ShakingWidget(
                            child: SizedBox(
                              height: setting.bottomImageHeight,
                              width: setting.bottomImageWidth,
                              child: (highScore == 100 &&
                                      setting.bottomImageWin.isNotEmpty)
                                  ? Image.file(
                                      File(setting.bottomImageWin),
                                      fit: BoxFit.contain,
                                    )
                                  : (highScore < 100 &&
                                          setting.bottomImageLose.isNotEmpty)
                                      ? Image.file(
                                          File(setting.bottomImageLose),
                                          fit: BoxFit.contain,
                                        )
                                      : Image.asset(appImages[highScore < 100
                                          ? "IMG_GLOBE_3"
                                          : "IMG_GLOBE_2"]!),
                            ),
                          )
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
                              child: Image.file(
                                File(setting.footerImage),
                                fit: BoxFit.contain,
                              ),
                              // child: setting.footerImage.isNotEmpty
                              //     ? Image.file(
                              //         File(setting.footerImage),
                              //         fit: BoxFit.contain,
                              //       )
                              //     : Image.asset(appImages["IMG_FOOTER"]!),
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
                  child: Row(children: [
                    TouchableOpacity(
                      onPress: () async {
                        windowManager
                            .setFullScreen(isFullscreen ? false : true);
                        isFullscreen = isFullscreen ? false : true;
                        setState(() {});
                      },
                      child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Icon(
                            isFullscreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: const Color.fromARGB(162, 255, 255, 255),
                            size: 26,
                          )),
                    ),
                    PopUp(
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
                        color: Color.fromARGB(162, 255, 255, 255),
                        size: 24,
                      ),
                    )
                  ])),
              if (win)
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset(appImages["IMG_CONFETTI"]!,
                      fit: BoxFit.contain),
                )
            ],
          ),
        ),
      ),
    );
  }
}
