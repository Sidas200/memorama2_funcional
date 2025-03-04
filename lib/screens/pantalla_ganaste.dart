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
      appBar: AppBar(
        title: Text("¡Ganaste!"),
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
            // Imagen del trofeo
            Image.asset(
              'resources/images/trofeo.png', // Asegúrate de tener esta imagen en assets
              height: 100,
            ),
            SizedBox(height: 20),

            // Texto principal
            Text(
              "¡Ganaste!!\nFelicidades!!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Estadísticas
            Text("Tiempo: ${tiempo}s", style: TextStyle(fontSize: 18)),
            Text("Movimientos: $movimientos", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),

            // Botón "Volver a jugar"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5B97A), // Color beige-naranja
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

            // Botón "Menú principal"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5B97A), // Color beige-naranja
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Menú principal", style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}