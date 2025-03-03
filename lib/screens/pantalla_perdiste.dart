import 'package:flutter/material.dart';
import 'package:memorama2/app/home.dart';
import 'package:memorama2/config/config.dart';
import 'package:memorama2/widgets/tablero.dart';

class PantallaPerdiste extends StatelessWidget {
  final int movimientos;

  final int paresRestantes;

  final int paresTotales;

  final Nivel? nivel;

  const PantallaPerdiste({super.key, required this.movimientos, required this.nivel, required this.paresRestantes, required this.paresTotales});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perdiste :(")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¡Perdiste!! Sigue intentando!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text("Pares totales: $paresTotales", style: TextStyle(fontSize: 18)),
            Text("Pares restantes: $paresRestantes", style: TextStyle(fontSize: 18)),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              child: Text("Salir al menu"),
            ),
          ],
        ),
      ),
    );
  }
}