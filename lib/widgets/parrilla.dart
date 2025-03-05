import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:memorama2/app/home.dart';
import 'package:memorama2/screens/pantalla_ganaste.dart';
import 'package:memorama2/screens/pantalla_perdiste.dart';
import '../config/config.dart';

class Parrilla extends StatefulWidget {
  final Nivel? nivel;

  const Parrilla(this.nivel, {Key? key}) : super(key: key);

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

    Future.delayed(Duration(milliseconds: 500), () {
      for (var controller in controles) {
        controller.toggleCard();
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;

      for (var controller in controles) {
        controller.toggleCard();
      }

      setState(() {
        habilitado = true;
        empezar = true;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!pauseClock) {
          setState(() {
            if (segundos! > 0) {
              segundos = segundos! - 1;
            } else {
              _timer?.cancel();
              derrotasGlobal++;
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
      victoriasGlobal++;
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Pares restantes: $paresRestantes",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
                  Text("Pares total: $paresTotales",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
                  Text("Movimientos: $movimientos",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("🏆 Victorias: $victoriasGlobal",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
                  Text("😢 Derrotas: $derrotasGlobal",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16),
                      Text(
                        " ${segundos! ~/ 60}:${(segundos! % 60).toString().padLeft(2, '0')} min",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const crossAxisCount = 4;
              final rowCount = (baraja.length / crossAxisCount).ceil();
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final itemWidth = width / crossAxisCount;
              final itemHeight = height / rowCount;
              final aspectRatio = itemWidth / itemHeight;

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: baraja.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (context, index) {
                  return FlipCard(
                    onFlip: () {
                      if (!habilitado!) return;

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

                        if (baraja.elementAt(index) == baraja.elementAt(prevclicked!)) {
                          debugPrint("clicked: Son iguales");
                          setState(() {
                            paresRestantes = paresRestantes! - 1;
                            habilitado = true;
                          });
                          prevclicked = -1;
                          Ganador();
                        } else {
                          Future.delayed(
                            Duration(seconds: 1),
                                () {
                              controles.elementAt(prevclicked!).toggleCard();
                              estados[prevclicked!] = true;
                              prevclicked = index;
                              controles.elementAt(index).toggleCard();
                              estados[index] = true;
                              setState(() {
                                habilitado = true;
                              });
                            },
                          );
                        }
                      } else {
                        setState(() {
                          habilitado = true;
                        });
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
                    flipOnTouch: habilitado! ? estados.elementAt(index) : false,
                    front: Image.asset("resources/images/pokemon.png"),
                    back: Image.asset(baraja[index]),
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
