import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:memorama2/app/home.dart';
import 'package:memorama2/screens/pantalla_ganaste.dart';
import 'package:memorama2/screens/pantalla_perdiste.dart';
import '../config/config.dart';

class Parrilla extends StatefulWidget {
  final Nivel? nivel;
  final Function(bool) onGameEnd;

  const Parrilla(this.nivel, {Key? key, required this.onGameEnd}) : super(key: key);

  @override
  _ParrillaState createState() => _ParrillaState();
}

class _ParrillaState extends State<Parrilla> {
  int? prevclicked;
  bool? empezar;
  int? paresTotales;
  int? movimientos;
  int? paresRestantes;
  int? segundos;
  Timer? _timer;
  bool? flag, habilitado;

  @override
  void initState() {
    super.initState();
    empezar = false;
    controles = [];
    baraja = [];
    estados = [];
    barajar(widget.nivel!);

    prevclicked = -1;
    flag = false;
    habilitado = false;
    paresTotales = baraja.length ~/ 2;
    paresRestantes = paresTotales;
    movimientos = 0;
    segundos = 180;
    pauseClock = false;

    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!pauseClock) {
          setState(() {
            habilitado = true;
            if (segundos! > 0) {
              segundos = segundos! - 1;
            } else {
              widget.onGameEnd(false);
              _timer?.cancel();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaPerdiste(
                    movimientos: movimientos!,
                    paresRestantes: paresRestantes!,
                    paresTotales: paresTotales!,
                    nivel: widget.nivel,
                  ),
                ),
              );
            }
          });
        }
      });
    });
  }

  void Ganador() {
    if (paresRestantes == 0) {
      widget.onGameEnd(true);
      _timer?.cancel();
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaGanaste(
              movimientos: movimientos!,
              tiempo: segundos!,
              nivel: widget.nivel,
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contenedor con la información de arriba
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red[200],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                spreadRadius: 4,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Pares: $paresRestantes",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
              Text("Pares total: $paresTotales",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
              Text("Movimientos: $movimientos",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
              Text(
                "Tiempo: ${segundos! ~/ 60}:${(segundos! % 60).toString().padLeft(2, '0')}s",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const crossAxisCount = 4;

              // Calculamos cuántas filas en función del total de cartas
              final rowCount = (baraja.length / crossAxisCount).ceil();

              // Ancho y alto total disponibles para el grid
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              // Tamaño de cada celda
              final itemWidth = width / crossAxisCount;
              final itemHeight = height / rowCount;

              // Relación de aspecto para que todas entren sin scroll
              final aspectRatio = itemWidth / itemHeight;

              return GridView.builder(
                // Desactivamos el scroll para que no haya desplazamiento
                physics: const NeverScrollableScrollPhysics(),
                itemCount: baraja.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (context, index) {
                  return FlipCard(
                    onFlip: () {
                      if (empezar!) {
                        if (!flag!) {
                          prevclicked = index;
                          estados[index] = false;
                        } else {
                          setState(() {
                            habilitado = false;
                          });
                        }
                        flag = !flag!;
                        estados[index] = false;

                        if (prevclicked != index && !flag!) {
                          movimientos = movimientos! + 1;
                          if (baraja[index] == baraja[prevclicked!]) {
                            setState(() {
                              paresRestantes = paresRestantes! - 1;
                              habilitado = true;
                            });
                            Ganador();
                          } else {
                            Future.delayed(const Duration(seconds: 1), () {
                              controles[prevclicked!].toggleCard();
                              estados[prevclicked!] = true;
                              prevclicked = index;
                              controles[index].toggleCard();
                              estados[index] = true;
                              setState(() {
                                habilitado = true;
                              });
                            });
                          }
                        } else {
                          setState(() {
                            habilitado = true;
                          });
                        }
                      }
                    },
                    onFlipDone: (isFront) {
                      if (!empezar!) {
                        setState(() {
                          empezar = true;
                        });
                      }
                    },
                    fill: Fill.fillBack,
                    controller: controles[index],
                    autoFlipDuration: const Duration(seconds: 3),
                    flipOnTouch: habilitado! ? estados[index] : false,
                    front: Image.asset(baraja[index]),
                    back: Image.asset("resources/images/pokemon.png"),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

