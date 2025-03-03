import 'package:flutter/material.dart';
import 'package:memorama2/widgets/tablero.dart';
import 'package:memorama2/config/config.dart';
import '../db/sqlite.dart';

class Consulta extends StatefulWidget {
  final Nivel? nivel;

  const Consulta(this.nivel, {Key? key}) : super(key: key);

  @override
  _ConsultaState createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  List<Map<String, dynamic>> historial = [];

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    List<Map<String, dynamic>> data = List.from(await Sqlite.consultar());
    data.sort((a, b) => (b['fecha'] ?? '').compareTo(a['fecha'] ?? ''));
    setState(() {
      historial = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Estadísticas"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Victorias actuales: $victoriasGlobal",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text("Derrotas actuales: $derrotasGlobal",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: historial.length,
              itemBuilder: (context, index) {
                final partida = historial[index];
                return ListTile(
                  title: Text("Fecha: ${partida['fecha'] ?? 'Desconocida'}",
                      style: const TextStyle(fontSize: 16)),
                  subtitle: Text(
                      "Victorias: ${partida['victorias'] ?? 0} | Derrotas: ${partida['derrotas'] ?? 0}",
                      style: const TextStyle(fontSize: 14)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Tablero(widget.nivel)),
                    );
                  },
                  child: const Text("Volver a jugar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Salir al menú"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
