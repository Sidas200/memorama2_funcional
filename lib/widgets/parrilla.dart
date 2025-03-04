import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memorama2/app/home.dart';
import 'package:memorama2/screens/pantalla_ganaste.dart';
import 'package:memorama2/screens/pantalla_perdiste.dart';
import '../config/config.dart';
import 'package:flip_card/flip_card.dart';

class Parrilla extends StatefulWidget {
  final Nivel? nivel;

  final Function(bool) onGameEnd;

  const Parrilla(this.nivel, {Key? key, required this.onGameEnd}) : super(key: key);

  @override
  _ParrillaState createState() => _ParrillaState();
}

class _ParrillaState extends State<Parrilla>  {
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
    empezar= false;
    controles = [];
    baraja = [];
    estados = [];
    barajar(widget.nivel!);
    prevclicked = -1;
    flag = false;
    habilitado=false;
    paresTotales = baraja.length ~/2;
    paresRestantes = paresTotales;
    movimientos=0;
    segundos=10;
    pauseClock=false;

    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!pauseClock) {
          setState(() {
            habilitado=true;
            if (segundos! > 0) {
              segundos = segundos! - 1;
            } else {
              widget.onGameEnd(false);
              _timer?.cancel();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
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
      Future.delayed(Duration(milliseconds: 100), () {
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
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.pink[200],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius:4,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Pares: $paresRestantes",  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12),),
              Text("Pares total: $paresTotales", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
              Text("Movimientos: $movimientos", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
              Text("Tiempo: ${segundos}s", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 12)),
            ],
          ),
        ),

        SizedBox(height: 10),

        Expanded(
          child: GridView.builder(
            itemCount: baraja.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
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
                      if (baraja.elementAt(index) ==
                          baraja.elementAt(prevclicked!)) {
                        setState(() {
                          paresRestantes = paresRestantes! - 1;
                          habilitado = true;
                        });
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
                flipOnTouch: habilitado! ? estados.elementAt(index) : false,
                front: Image.asset(baraja[index]),
                back: Image.asset("resources/images/pokemon.png"),
              );
            },
          ),
        ),
      ],
    );
  }
}
