import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memorama2/widgets/parrilla.dart';

import '../app/home.dart';
import '../config/config.dart';
import '../db/sqlite.dart';
import '../screens/consulta.dart';

enum MenuOpciones { juego_nuevo,reiniciar, consultar, salir }

class Tablero extends StatefulWidget {
  final Nivel? nivel;

  const Tablero(this.nivel, {Key? key}) : super(key: key);

  @override
  _TableroState createState() => _TableroState();
}

class _TableroState extends State<Tablero> {


  @override
  void initState() {
    super.initState();
  }

  void resultado(bool gano) {
    setState(() {
      if (gano) {
        victoriasGlobal++;
      } else {
        derrotasGlobal++;
      }
    });
  }

  void mostrarDialogo(String titulo, String contenido, VoidCallback onConfirmar) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF5DEB3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            contenido,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5B97A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                pauseClock = false;
              },
              child: Text(
                "No",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5B97A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmar();
              },
              child: Text(
                "Sí",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }


  Future<void> handleMenu(MenuOpciones opcion) async {
    pauseClock=true;
    switch (opcion) {
      case MenuOpciones.reiniciar:
        mostrarDialogo(
          "Reiniciar Juego",
          "¿Estás seguro de que quieres reiniciar la partida?, se perdera el progeso",
              () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Tablero(widget.nivel)),
            );
          },
        );
        break;
      case MenuOpciones.consultar:
        mostrarDialogo(
          "Consultar",
          "¿Quieres abrir la consulta?, se perdera el progreso de la partida",
              () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Consulta(widget.nivel)),
            );
          },
        );
        break;
      case MenuOpciones.juego_nuevo:
        mostrarDialogo(
          "Juego nuevo",
          "¿Quieres empezar un nuevo juego?, se contrara como partida perdida",
              () {
            setState(() {
              derrotasGlobal++;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Tablero(widget.nivel)),
            );
          },
        );
        break;
      case MenuOpciones.salir:
        mostrarDialogo(
          "Salir",
          "¿Seguro que quieres salir?, se guardara la información en la base de datos",
              () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
                await Sqlite.guardar(victoriasGlobal, derrotasGlobal, widget.nivel!.name);
          },
        );
        break;
    }
  }
  PopupMenuItem<MenuOpciones> _construirMenu(MenuOpciones value, String text) {
    return PopupMenuItem(
      value: value,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFFFFB366),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.of(context).pop();
              await Sqlite.guardar(victoriasGlobal, derrotasGlobal, widget.nivel!.name);
              },
            ),
        title: Text("Nivel: ${widget.nivel?.name}"),
        actions: [
          PopupMenuButton<MenuOpciones>(
            onSelected: handleMenu,
            color: Color(0xFFFFD699),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Bordes redondeados
            ),
            itemBuilder: (context) => [
              _construirMenu(MenuOpciones.juego_nuevo, "Juego nuevo"),
              _construirMenu(MenuOpciones.reiniciar, "Reiniciar"),
              _construirMenu(MenuOpciones.consultar, "Consultar"),
              _construirMenu(MenuOpciones.salir, "Salir"),
            ],
          ),
        ],
      ),
      body: Parrilla(widget.nivel, finJuego: resultado,),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFF5DEB3),
        shape: CircularNotchedRectangle(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.black),
                  onPressed: () {
                    pauseClock=true;
                    mostrarDialogo(
                        "Jugar de nuevo", "¿Quieres cargar un juego nuevo?, se contará como partida perdida", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Tablero(widget.nivel)),
                      );
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.black),
                  onPressed: () {
                    pauseClock=true;
                    mostrarDialogo(
                        "Reiniciar", "¿Seguro que deseas reiniciar la partida?, se perderá el progreso del juego", () {
                      setState(() {
                        derrotasGlobal++;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Tablero(widget.nivel)),
                      );
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    pauseClock=true;
                    mostrarDialogo(
                        "Consultar", "¿Seguro que quieres consultar?, se perderá el progreso del juego", () {
                      setState(() {
                        derrotasGlobal++;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Consulta(widget.nivel)),
                      );
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.black),
                  onPressed: () async {
                    pauseClock=true;
                    mostrarDialogo("Salir", "¿Seguro que quieres salir?, se guardará la información en la base de datos", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    });
                    await Sqlite.guardar(victoriasGlobal, derrotasGlobal, widget.nivel!.name);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

