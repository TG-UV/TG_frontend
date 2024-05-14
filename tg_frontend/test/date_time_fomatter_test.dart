import 'package:flutter_test/flutter_test.dart';
import 'package:tg_frontend/utils/date_Formatter.dart';

DateTime dateTimeTest = DateTime.now();

void main() {
  {
    test('Formatear fecha formato "yyyy-MM-dd" a formato "EEEE, d MMMM"', () {
      expect(DateFormatter().dateFormatedTextController(dateTimeTest),
          "Lunes, 13 mayo");
    });

    test('Formatear fecha con formato "DateTime" a formato " yyyy-MM-dd"', () {
      expect(DateFormatter().dateFormatedToSend(dateTimeTest), "2024-05-13");
    });

    test('Formatear hora en formato "hh:mm:ss" a formato "hh:mm a"', () {
      expect(DateFormatter().timeFormatedTextController("10:00:00"),
          "10:00 a. m.");
    });
  }
}
