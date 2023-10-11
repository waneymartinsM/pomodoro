import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

// Extensão para adicionar funcionalidades matemáticas úteis a tipos numéricos:
extension MathHelpers on num {
  double get toRad => this * (math.pi / 180.0); // Converte graus em radianos

  // Divide o número pelo numerador e denominador especificados:
  double divideToFraction({
    required num numerator,
    required num denominator,
  }) =>
      this * numerator / denominator;

  int get secToMinutes => this ~/ 60; // Converte segundos em minutos
  int get secLeft => (this % 60)
      .toInt(); // Obtém os segundos restantes após a conversão para minutos
  bool isAroundOf(double value, double around) =>
      (this - value).abs() <=
      around; // Verifica se um número está dentro de uma determinada proximidade de outro número
}

// Extensão para adicionar funcionalidades úteis a objetos do tipo Size:
extension SizeHelpers on Size {
  Offset get centerOffset => Offset(
      width / 2, height / 2); // Obtém o deslocamento do centro de um tamanho

  Rect get centerRect => Rect.fromCenter(
      center: centerOffset,
      width: width,
      height: height); // Cria um retângulo centrado com base no tamanho

  // Cria um shader (gradiente) com base em uma lista de cores e um ângulo especificado:
  Shader makeShader(List<Color> colors, double deg) {
    return SweepGradient(
      colors: colors,
      transform: GradientRotation(deg.toRad),
    ).createShader(centerRect);
  }
}

// Extensão para adicionar funcionalidades úteis a objetos do tipo List<Color>:
extension LinearGradientMaker on List<Color> {
  // Cria um gradiente linear com base em uma lista de cores

  LinearGradient get getLinearGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: this,
      );
}

// Extensão para adicionar funcionalidades úteis a objetos do tipo DateTime:
extension DateTimeHelper on DateTime {
  bool isInSameDay(DateTime other) =>
      year == other.year &&
      month == other.month &&
      day == other.day; // Verifica se duas datas estão no mesmo dia

  DateTime get roundToDay => DateTime(year, month,
      day); // Arredonda uma data para o dia, removendo as informações de hora

  String get convertToDateString =>
      '$year/$month/$day'; // Converte uma data em uma string no formato "ano/mês/dia"
}

// Extensão para adicionar funcionalidades úteis a objetos do tipo Date (Jalali ou Gregorian):
extension DateHelper on Date {
  bool isInSameDay(Date other) =>
      year == other.year &&
      month == other.month &&
      day ==
          other
              .day; // Verifica se duas datas (Jalali ou Gregorian) estão no mesmo dia

  // Arredonda uma data (Jalali ou Gregorian) para o dia:
  Date get roundToDay {
    if (this is Jalali) return Jalali(year, month, day);
    return Gregorian(year, month, day);
  }

  String get convertToDateString =>
      '$year/$month/$day'; // Converte uma data em uma string no formato "ano/mês/dia"
}
