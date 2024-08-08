import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:screamtowin/constant.dart';
import 'package:screamtowin/models/setting.model.dart';
import 'package:screamtowin/utils.dart';

import 'widgets/button/button_opacity.dart';
import 'widgets/input.dart';
import 'widgets/picker_color.dart';
import 'widgets/picker_image.dart';

class PopUpSetting extends StatefulWidget {
  final void Function() refresh;

  const PopUpSetting({super.key, required this.refresh});

  @override
  State<PopUpSetting> createState() => _PopUpSettingState();
}

class _PopUpSettingState extends State<PopUpSetting> {
  SettingModel settingOld = SettingModel();
  SettingModel setting = SettingModel();

  TextEditingController controllerSensitivity = TextEditingController();
  TextEditingController controllerDuration = TextEditingController();
  TextEditingController controllerHeaderText = TextEditingController();
  TextEditingController controllerHeaderTextWin = TextEditingController();
  TextEditingController controllerHeaderSubText = TextEditingController();
  TextEditingController controllerHeaderSubTextFontSize =
      TextEditingController();
  TextEditingController controllerHeaderTextFontSize = TextEditingController();
  TextEditingController controllerHeaderImageHeight = TextEditingController();
  TextEditingController controllerHeaderImageWidth = TextEditingController();
  TextEditingController controllerBottomImageHeight = TextEditingController();
  TextEditingController controllerBottomImageWidth = TextEditingController();
  TextEditingController controllerFooterImageHeight = TextEditingController();
  TextEditingController controllerFooterImageWidth = TextEditingController();
  TextEditingController controllerScoreFontSize = TextEditingController();
  TextEditingController controllerBarImageHeight = TextEditingController();
  TextEditingController controllerBarImageWidth = TextEditingController();

  @override
  void initState() {
    super.initState();
    readStorage(
        key: "setting",
        cb: (value) {
          if (value != null) {
            setting = SettingModel.fromJson(jsonDecode(value));
          } else {
            writeStorage(key: "setting", value: jsonEncode(setting.toJson()));
          }
          controllerSensitivity.text = setting.sensitivity.toString();
          controllerDuration.text = setting.duration.toString();
          controllerHeaderText.text = setting.headerText;
          controllerHeaderTextWin.text = setting.headerTextWin;
          controllerHeaderSubText.text = setting.headerSubText;
          controllerHeaderSubTextFontSize.text =
              setting.headerSubTextFontSize.toString();
          controllerHeaderTextFontSize.text =
              setting.headerTextFontSize.toString();
          controllerHeaderImageHeight.text =
              setting.headerImageHeight.toString();
          controllerHeaderImageWidth.text = setting.headerImageWidth.toString();
          controllerBottomImageHeight.text =
              setting.bottomImageHeight.toString();
          controllerBottomImageWidth.text = setting.bottomImageWidth.toString();
          controllerFooterImageHeight.text =
              setting.footerImageHeight.toString();
          controllerFooterImageWidth.text = setting.footerImageWidth.toString();
          controllerScoreFontSize.text = setting.scoreFontSize.toString();
          controllerBarImageHeight.text = setting.barImageHeight.toString();
          controllerBarImageWidth.text = setting.barImageWidth.toString();
          setState(() {});
        });
  }

  void handlerSaveSetting() async {
    if (setting.backgroundImage != settingOld.backgroundImage) {
      setting.backgroundImage = await saveImage(setting.backgroundImage);
    }

    if (setting.headerImage != settingOld.headerImage) {
      setting.headerImage = await saveImage(setting.headerImage);
    }

    if (setting.bottomImage != settingOld.bottomImage) {
      setting.bottomImage = await saveImage(setting.bottomImage);
    }

    if (setting.footerImage != settingOld.footerImage) {
      setting.footerImage = await saveImage(setting.footerImage);
    }

    if (setting.barImage20 != settingOld.barImage20) {
      setting.barImage20 = await saveImage(setting.barImage20);
    }
    if (setting.barImage40 != settingOld.barImage40) {
      setting.barImage40 = await saveImage(setting.barImage40);
    }
    if (setting.barImage60 != settingOld.barImage60) {
      setting.barImage60 = await saveImage(setting.barImage60);
    }
    if (setting.barImage80 != settingOld.barImage80) {
      setting.barImage80 = await saveImage(setting.barImage80);
    }
    if (setting.barImage100 != settingOld.barImage100) {
      setting.barImage100 = await saveImage(setting.barImage100);
    }

    await writeStorage(key: "setting", value: jsonEncode(setting.toJson()));
    widget.refresh();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void handlerSaveDefault() async {
    await writeStorage(
        key: "setting", value: jsonEncode(SettingModel().toJson()));
    widget.refresh();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "ATUR TAMPILAN",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Input(
                              label: "Sensitivitas Suara",
                              controller: controllerSensitivity,
                              margin: const EdgeInsets.only(top: 8, bottom: 12),
                              width: 200,
                              onChanged: (value) => setState(() {
                                setting.sensitivity = double.parse(
                                    value.isNotEmpty ? value : "0");
                              }),
                            ),
                            Input(
                              label: "Durasi Mendengarkan Suara (detik)",
                              controller: controllerDuration,
                              margin: const EdgeInsets.only(top: 8, bottom: 12),
                              width: 200,
                              onChanged: (value) => setState(() {
                                setting.duration =
                                    int.parse(value.isNotEmpty ? value : "0");
                              }),
                            ),
                            const Text("Warna Background ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                )),
                            PickerColor(
                                margin:
                                    const EdgeInsets.only(top: 4, bottom: 12),
                                value: setting.backgroundColor,
                                onSubmit: (color) => setState(
                                    () => setting.backgroundColor = color)),
                            const Text("Gambar Background ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                )),
                            PickerImage(
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                path: setting.backgroundImage,
                                onChange: (image) => setState(
                                    () => setting.backgroundImage = image)),
                            Input(
                              label: "Ukuran Text Skor",
                              controller: controllerScoreFontSize,
                              margin: const EdgeInsets.only(top: 8, bottom: 12),
                              width: 200,
                              onChanged: (value) => setState(() {
                                setting.scoreFontSize = double.parse(
                                    value.isNotEmpty ? value : "0");
                              }),
                            ),
                            const Text("Warna Text Skor",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                )),
                            PickerColor(
                                margin:
                                    const EdgeInsets.only(top: 4, bottom: 12),
                                value: setting.scoreColor,
                                onSubmit: (color) =>
                                    setState(() => setting.scoreColor = color)),
                          ],
                        )),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.5,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Header",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              const Text("Header Image",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  )),
                              PickerImage(
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 12),
                                  path: setting.headerImage,
                                  onChange: (image) => setState(
                                      () => setting.headerImage = image)),
                              Input(
                                label: "Tinggi Header Image",
                                controller: controllerHeaderImageHeight,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.headerImageHeight = double.parse(
                                      value.isNotEmpty ? value : "0");
                                }),
                              ),
                              Input(
                                label: "Lebar Header Image",
                                controller: controllerHeaderImageWidth,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.headerImageWidth = double.parse(
                                      value.isNotEmpty ? value : "0");
                                }),
                              ),
                              Input(
                                label: "Teks header",
                                controller: controllerHeaderText,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.headerText = value;
                                }),
                              ),
                              Input(
                                label: "Teks header kemenangan",
                                controller: controllerHeaderTextWin,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.headerTextWin = value;
                                }),
                              ),
                              Input(
                                label: "Teks sub header",
                                controller: controllerHeaderSubText,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.headerSubText = value;
                                }),
                              ),
                              Input(
                                label: "Ukuran Text Header",
                                controller: controllerHeaderTextFontSize,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.headerTextFontSize = double.parse(
                                      value.isNotEmpty ? value : "0");
                                }),
                              ),
                              Input(
                                label: "Ukuran Text Sub Header",
                                controller: controllerHeaderSubTextFontSize,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.headerSubTextFontSize = double.parse(
                                      value.isNotEmpty ? value : "0");
                                }),
                              ),
                              const Text("Warna Text Header ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  )),
                              PickerColor(
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 12),
                                  value: setting.headerTextColor,
                                  onSubmit: (color) => setState(
                                      () => setting.headerTextColor = color)),
                              const Text("Warna Text Sub Header ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  )),
                              PickerColor(
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 12),
                                  value: setting.headerSubTextColor,
                                  onSubmit: (color) => setState(() =>
                                      setting.headerSubTextColor = color)),
                            ],
                          )),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.5,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Body",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text("Gunakan Gambar Bar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          )),
                                    ),
                                    Switch(
                                      value: setting.useBarImage,
                                      onChanged: (v) {
                                        setting.useBarImage = v;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (setting.useBarImage)
                                Input(
                                  label: "Tinggi Gambar Bar",
                                  controller: controllerBarImageHeight,
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 6),
                                  width: 200,
                                  onChanged: (value) => setState(() {
                                    setting.barImageHeight = double.parse(
                                        value.isNotEmpty ? value : "0");
                                  }),
                                ),
                              if (setting.useBarImage)
                                Input(
                                  label: "Lebar Gambar Bar",
                                  controller: controllerBarImageHeight,
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 20),
                                  width: 200,
                                  onChanged: (value) => setState(() {
                                    setting.barImageWidth = double.parse(
                                        value.isNotEmpty ? value : "0");
                                  }),
                                ),
                              if (setting.useBarImage)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Gambar Bar 20%",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                )),
                                            PickerImage(
                                                margin: const EdgeInsets.only(
                                                    top: 8, bottom: 12),
                                                path: setting.barImage20,
                                                onChange: (image) => setState(
                                                    () => setting.barImage20 =
                                                        image)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Gambar Bar 40%",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                )),
                                            PickerImage(
                                                margin: const EdgeInsets.only(
                                                    top: 8, bottom: 12),
                                                path: setting.barImage40,
                                                onChange: (image) => setState(
                                                    () => setting.barImage40 =
                                                        image)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Gambar Bar 60%",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                )),
                                            PickerImage(
                                                margin: const EdgeInsets.only(
                                                    top: 8, bottom: 12),
                                                path: setting.barImage60,
                                                onChange: (image) => setState(
                                                    () => setting.barImage60 =
                                                        image)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Gambar Bar 80%",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                )),
                                            PickerImage(
                                                margin: const EdgeInsets.only(
                                                    top: 8, bottom: 12),
                                                path: setting.barImage80,
                                                onChange: (image) => setState(
                                                    () => setting.barImage80 =
                                                        image)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Gambar Bar 100%",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                )),
                                            PickerImage(
                                                margin: const EdgeInsets.only(
                                                    top: 8, bottom: 12),
                                                path: setting.barImage100,
                                                onChange: (image) => setState(
                                                    () => setting.barImage100 =
                                                        image)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const Text("Gambar Bawah",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  )),
                              PickerImage(
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 12),
                                  path: setting.bottomImage,
                                  onChange: (image) => setState(
                                      () => setting.bottomImage = image)),
                              const Text("Gambar Bawah Win",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  )),
                              PickerImage(
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 12),
                                  path: setting.bottomImageWin,
                                  onChange: (image) => setState(
                                      () => setting.bottomImageWin = image)),
                              Input(
                                label: "Tinggi Gambar Bawah",
                                controller: controllerBottomImageHeight,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.bottomImageHeight = double.parse(
                                      value.isNotEmpty ? value : "0");
                                }),
                              ),
                              Input(
                                label: "Lebar Gambar Bawah",
                                controller: controllerBottomImageWidth,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.bottomImageWidth = double.parse(
                                      value.isNotEmpty ? value : "0");
                                }),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.5,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Footer",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              const Text("Footer Image",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  )),
                              PickerImage(
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 12),
                                  path: setting.footerImage,
                                  onChange: (image) => setState(
                                      () => setting.footerImage = image)),
                              Input(
                                label: "Tinggi Footer Image",
                                controller: controllerFooterImageHeight,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.footerImageHeight = double.parse(
                                      value.isNotEmpty ? value : "0");
                                }),
                              ),
                              Input(
                                label: "Lebar Footer Image",
                                controller: controllerFooterImageWidth,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.footerImageWidth = double.parse(
                                      value.isNotEmpty ? value : "0");
                                }),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ]))),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TouchableOpacity(
                    onPress: handlerSaveDefault,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: const Text("Default",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    )),
                const SizedBox(
                  width: 24,
                ),
                TouchableOpacity(
                    onPress: handlerSaveSetting,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: const BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: const Text("Simpan",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
