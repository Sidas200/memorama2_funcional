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
      appBar: AppBar(
        title: Text("Perdiste :("),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'resources/images/perdiste.png',
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              "Perdiste\nSigue intentándolo!!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "outfit"),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text("Movimientos: $movimientos", style: TextStyle(fontSize: 18)),
            Text("Pares encontrados: ${paresTotales - paresRestantes}", style: TextStyle(fontSize: 18)),
            Text("Pares restantes: $paresRestantes", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5B97A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Tablero(nivel)),
                );
              },
              child: Text("Volver a jugar", style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5B97A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              child: Text("Menú principal", style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}