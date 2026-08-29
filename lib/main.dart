import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui_web' as ui_web;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'models/game_state.dart';
import 'services/game_loop.dart';

void main() {
  if (kIsWeb) {
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'three-js-canvas',
      (int viewId) {
        html.IFrameElement iframe = html.IFrameElement()
          ..src = 'assets/game_3d.html'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return iframe;
      },
    );
  }
  runApp(const EcoviaApp());
}

class EcoviaApp extends StatelessWidget {
  const EcoviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E2229),
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
          secondary: Colors.tealAccent,
        ),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameState _gameState = GameState();
  late GameLoop _gameLoop;

  @override
  void initState() {
    super.initState();
    _gameLoop = GameLoop(_gameState);
    _gameLoop.start();
    _gameState.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _gameLoop.stop();
    super.dispose();
  }

  Widget _buildProgressBar(String label, double value, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 6),
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              Text("${value.toStringAsFixed(1)} / 1000", style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value / 1000.0,
              backgroundColor: Colors.white12,
              color: color,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingButton(String title, String subtitle, IconData icon, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF343B48),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.greenAccent)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ecovia: Civilización Viva (3D Interactivo)", style: TextStyle(fontSize: 15)),
        centerTitle: true,
        backgroundColor: const Color(0xFF14171C),
      ),
      body: Column(
        children: [
          // Vista 3D con altura fija garantizada para que se renderice correctamente
          SizedBox(
            height: 260,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const HtmlElementView(viewType: 'three-js-canvas'),
              ),
            ),
          ),

          // Panel Inferior con Scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Estado de la Civilización
                  Card(
                    color: const Color(0xFF2A303C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(_gameState.nombreNivel.toUpperCase(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                          const SizedBox(height: 6),
                          _buildProgressBar("Biomasa", _gameState.biomasa, Colors.green, Icons.eco),
                          _buildProgressBar("Energía", _gameState.energia, Colors.amber, Icons.bolt),
                          _buildProgressBar("Agua", _gameState.agua, Colors.lightBlue, Icons.water_drop),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Infraestructura
                  Card(
                    color: const Color(0xFF2A303C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("INFRAESTRUCTURA BIO-INTEGRADA", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2)),
                          const SizedBox(height: 6),
                          _buildBuildingButton(
                            "Invernadero (${_gameState.invernaderos})", 
                            "50 Bio / 30 En.", 
                            Icons.house, 
                            Colors.green, 
                            _gameState.construirInvernadero,
                          ),
                          _buildBuildingButton(
                            "Central Solar (${_gameState.centralesSolares})", 
                            "40 Bio / 40 Agua", 
                            Icons.solar_power, 
                            Colors.amber, 
                            _gameState.construirCentralSolar,
                          ),
                          _buildBuildingButton(
                            "Pozo de Agua (${_gameState.pozosAgua})", 
                            "50 Energía", 
                            Icons.water, 
                            Colors.lightBlue, 
                            _gameState.construirPozoAgua,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}