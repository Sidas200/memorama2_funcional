import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memorama2/widgets/parrilla.dart';



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

  void mostrarDialogo(String titulo, String contenido,
      VoidCallback onConfirmar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(contenido),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                pauseClock = false,
              },
              child: Text("Cancelar"),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmar();
              },
              child: Text("Aceptar"),
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
          "¿Estás seguro de que quieres reiniciar la partida?",
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
          "¿Quieres abrir la consulta?",
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
          "¿Quieres empezar un nuevo juego?",
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
          "¿Seguro que quieres salir?",
              () {
            SystemNavigator.pop();
          },
        );
        // se gurdaran los datos en la base de datos
        await Sqlite.guardar(victoriasGlobal, derrotasGlobal);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nivel: ${widget.nivel?.name}"),
        actions: [
          PopupMenuButton<MenuOpciones>(
            onSelected: handleMenu,
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                  value: MenuOpciones.juego_nuevo, child: Text("Juego nuevo")),
              PopupMenuItem(
                  value: MenuOpciones.reiniciar, child: Text("Reiniciar")),
              PopupMenuItem(
                  value: MenuOpciones.consultar, child: Text("Consultar")),
              PopupMenuItem(value: MenuOpciones.salir, child: Text("Salir")),
            ],
          ),
        ],
      ),
      body: Parrilla(widget.nivel, onGameEnd: resultado,),
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple[100],
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
                      SystemNavigator.pop();
                    });
                    await Sqlite.guardar(victoriasGlobal, derrotasGlobal);
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

