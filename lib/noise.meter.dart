import 'dart:math';

double log10(double x) {
  return log(x) / ln10;
}

int calculateDecibels(List<int> audioData) {
  // Convert List<int> to Int16List (assuming little-endian format)
  final int16List = <int>[];
  for (int i = 0; i < audioData.length; i += 2) {
    final highByte = audioData[i];
    final lowByte = audioData[i + 1];
    final sample = (highByte | (lowByte << 8)).toSigned(16);
    int16List.add(sample);
  }

  // Calculate RMS value
  double sumOfSquares = 0.0;
  for (var sample in int16List) {
    sumOfSquares += sample * sample;
  }
  double rms = sqrt(sumOfSquares / int16List.length);

  // To prevent log10 of zero or negative values, ensure rms is positive
  if (rms <= 0) rms = 1e-6; // Small value to avoid log10(0)

  // Convert RMS to Decibels
  double referenceValue = 32768.0; // Maximum value for 16-bit PCM
  double db = (20 * log10(rms / referenceValue)) + 77;

  // Apply a floor limit for low decibel values to avoid extreme negative values
  return db.toInt();
}

int calculateScore(int decibel) {
  double score = (max((decibel - 30), 0) / (70 / 100));
  return max(0, min(100, score.toInt()));
}
