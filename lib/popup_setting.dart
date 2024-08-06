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
                                setting.scoreFontSize = double.parse(value);
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
                                  setting.headerImageHeight =
                                      double.parse(value);
                                }),
                              ),
                              Input(
                                label: "Lebar Header Image",
                                controller: controllerHeaderImageWidth,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.headerImageWidth =
                                      double.parse(value);
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
                                  setting.headerTextFontSize =
                                      double.parse(value);
                                }),
                              ),
                              Input(
                                label: "Ukuran Text Sub Header",
                                controller: controllerHeaderSubTextFontSize,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.headerSubTextFontSize =
                                      double.parse(value);
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
                              const Text("Bottom Image",
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
                              const Text("Bottom Image Win",
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
                                label: "Tinggi Bottom Image",
                                controller: controllerBottomImageHeight,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.bottomImageHeight =
                                      double.parse(value);
                                }),
                              ),
                              Input(
                                label: "Lebar Bottom Image",
                                controller: controllerBottomImageWidth,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.bottomImageWidth =
                                      double.parse(value);
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
                                  setting.footerImageHeight =
                                      double.parse(value);
                                }),
                              ),
                              Input(
                                label: "Lebar Footer Image",
                                controller: controllerFooterImageWidth,
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  setting.footerImageWidth =
                                      double.parse(value);
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
