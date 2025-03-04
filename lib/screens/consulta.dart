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

  Color obtenerColorNivel(String nivel) {
    switch (nivel.toLowerCase()) {
      case "facil":
        return Colors.green;
      case "medio":
        return Colors.yellow;
      case "dificil":
        return Colors.orange;
      case "imposible":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de datos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('resources/images/trofeo.png', height: 30),
          const SizedBox(height: 5),
          Text("Partidas ganadas:\n$victoriasGlobal",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),

          Image.asset('resources/images/perdiste.png', height: 30),
          const SizedBox(height: 5),
          Text("Partidas perdidas:\n$derrotasGlobal",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),

          const Text("Historial", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: historial.length,
              itemBuilder: (context, index) {
                final partida = historial[index];
                final nivel = partida['nivel'] ?? 'Desconocido';
                final colorNivel = obtenerColorNivel(nivel);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFC0F1E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.black),
                          const SizedBox(width: 5),
                          Text("Fecha: ${partida['fecha'] ?? 'Desconocida'}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text("🏆 Victorias: ", style: TextStyle(fontSize: 16)),
                          Text("${partida['victorias'] ?? 0}"),
                          const SizedBox(width: 10),
                          const Text("😢 Derrotas: ", style: TextStyle(fontSize: 16)),
                          Text("${partida['derrotas'] ?? 0}"),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: colorNivel,
                          ),
                          const SizedBox(width: 5),
                          Text(nivel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF5B97A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Salir", style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF5B97A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Tablero(widget.nivel)),
                    );
                  },
                  child: const Text("Volver al juego", style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}