import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  double _biomasa = 999999.0;
  double _energia = 999999.0;
  double _agua = 999999.0;
  double _bioResonancia = 75.0;
  
  int _nivelCivilizacion = 1;

  // Cantidad de edificios construidos
  int _invernaderos = 0;
  int _centralesSolares = 0;
  int _pozosAgua = 0;

  double get biomasa => _biomasa;
  double get energia => _energia;
  double get agua => _agua;
  double get bioResonancia => _bioResonancia;
  int get nivelCivilizacion => _nivelCivilizacion;
  
  int get invernaderos => _invernaderos;
  int get centralesSolares => _centralesSolares;
  int get pozosAgua => _pozosAgua;

  String get nombreNivel {
    switch (_nivelCivilizacion) {
      case 1:
        return "Tribu Nómada";
      case 2:
        return "Asentamiento Sostenible";
      case 3:
        return "Tecno-Civilización Gaia";
      default:
        return "Civilización Estelar";
    }
  }

  void actualizarCiclo(double deltaTime) {
    double factorResonancia = _bioResonancia / 100.0;
    
    // Producción automática gracias a los edificios
    double produccionBiomasaExtra = _invernaderos * 3.0;
    double produccionEnergiaExtra = _centralesSolares * 3.0;
    double produccionAguaExtra = _pozosAgua * 2.0;

    // Variación dinámica y pasiva de los recursos
    _biomasa += ((8.0 + produccionBiomasaExtra) * factorResonancia) * deltaTime;
    _energia -= ((4.0 - produccionEnergiaExtra) * (2.0 - factorResonancia)) * deltaTime;
    _agua += ((produccionAguaExtra - 2.0) * factorResonancia) * deltaTime;

    // Limitar rangos entre 0 y 1000
    _biomasa = _biomasa.clamp(0.0, 1000.0);
    _energia = _energia.clamp(0.0, 1000.0);
    _agua = _agua.clamp(0.0, 1000.0);

    // Sistema de evolución por niveles automáticos
    if (_biomasa > 800 && _energia > 600 && _nivelCivilizacion == 1) {
      _nivelCivilizacion = 2;
    } else if (_biomasa > 950 && _energia > 800 && _nivelCivilizacion == 2) {
      _nivelCivilizacion = 3;
    }

    notifyListeners();
  }

  void impulsarResonancia() {
    _bioResonancia = (_bioResonancia + 5.0).clamp(0.0, 100.0);
    notifyListeners();
  }

  void recolectarAgua() {
    _agua = (_agua + 50.0).clamp(0.0, 1000.0);
    notifyListeners();
  }

  // Métodos para construir edificios gastando recursos
  void construirInvernadero() {
    if (_biomasa >= 50 && _energia >= 30) {
      _biomasa -= 50;
      _energia -= 30;
      _invernaderos++;
      notifyListeners();
    }
  }

  void construirCentralSolar() {
    if (_biomasa >= 40 && _agua >= 40) {
      _biomasa -= 40;
      _agua -= 40;
      _centralesSolares++;
      notifyListeners();
    }
  }

  void construirPozoAgua() {
    if (_energia >= 50) {
      _energia -= 50;
      _pozosAgua++;
      notifyListeners();
    }
  }
}