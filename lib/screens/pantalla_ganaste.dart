import 'package:flutter/material.dart';
import 'package:memorama2/widgets/tablero.dart';

import '../config/config.dart';

class PantallaGanaste extends StatelessWidget {
  final int movimientos;
  final int tiempo;

  final Nivel? nivel;

  const PantallaGanaste({Key? key, required this.movimientos, required this.tiempo, this.nivel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("¡Ganaste!")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¡Ganaste!! Felicidades!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text("Tiempo: ${tiempo}s", style: TextStyle(fontSize: 18)),
            Text("Movimientos: $movimientos", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Tablero(nivel),
                    settings: RouteSettings(name: "Parrilla"),
                  ),
                );
              },
              child: Text("Volver a jugar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Salir al menu"),
            ),
          ],
        ),
      ),
    );
  }
}