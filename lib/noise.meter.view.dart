import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:screamtowin/constant.dart';
import 'package:screamtowin/widgets/index.dart';

import 'noise.meter.dart';

class NoiseMeterView extends StatefulWidget {
  const NoiseMeterView({super.key});

  @override
  State<NoiseMeterView> createState() => _NoiseMeterViewState();
}

class _NoiseMeterViewState extends State<NoiseMeterView> {
  final record = AudioRecorder();
  Stream<Uint8List>? audioStream;
  int decibel = 0;
  var dialogId;

  @override
  void initState() {
    super.initState();
    listenScream();
  }

  @override
  void dispose() {
    record.stop();
    super.dispose();
  }

  void listenScream() async {
    if (await record.hasPermission()) {
      audioStream = await record
          .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
      audioStream!.listen((data) {
        decibel = calculateDecibels(data);
        if (calculateScore(decibel) == 100) viewWin();
        setState(() {});
      });
    }
  }

  // Views

  void viewWin() {
    if (dialogId != null) return;
    setState(() {
      audioStream = null;
    });
    dialogId = showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('SELAMAT'),
              content: const Text('Kamu Akan Umrah Sebentar Lagi!'),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            )).whenComplete(() {
      setState(() {
        dialogId = null;
      });
      listenScream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xFFC4D23F),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$decibel dB'),
              OutlinedText(
                  text: "Score Kamu : ${calculateScore(decibel)}",
                  fontSize: 52,
                  outlineColor: Colors.white,
                  textColor: primaryGreen),
            ],
          ),
        ),
      ),
    );
  }
}
