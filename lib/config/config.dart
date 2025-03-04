library config.globals;

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:memorama2/utilis/detalles.dart';

import '../widgets/tablero.dart';



enum Nivel {facil, medio, dificil,imposible}

int victoriasGlobal = 0;
int derrotasGlobal = 0;
bool pauseClock= false;

List<String> cards() {
  return [
    "resources/images/cloud.png",
    "resources/images/cloud.png",
    "resources/images/day.png",
    "resources/images/day.png",
    "resources/images/dino.png",
    "resources/images/dino.png",
    "resources/images/fish.png",
    "resources/images/fish.png",
    "resources/images/frog.png",
    "resources/images/frog.png",
    "resources/images/moon.png",
    "resources/images/moon.png",
    "resources/images/night.png",
    "resources/images/night.png",
    "resources/images/octo.png",
    "resources/images/octo.png",
    "resources/images/peacock.png",
    "resources/images/peacock.png",
    "resources/images/rabbit.png",
    "resources/images/rabbit.png",
    "resources/images/rain.png",
    "resources/images/rain.png",
    "resources/images/rainbow.png",
    "resources/images/rainbow.png",
    "resources/images/seahorse.png",
    "resources/images/seahorse.png",
    "resources/images/shark.png",
    "resources/images/shark.png",
    "resources/images/star.png",
    "resources/images/star.png",
    "resources/images/sun.png",
    "resources/images/sun.png",
    "resources/images/whale.png",
    "resources/images/whale.png",
    "resources/images/wolf.png",
    "resources/images/wolf.png",
    "resources/images/zoo.png",
    "resources/images/zoo.png"  ];
}

List<Detalles> botones =[
  Detalles("Facil",
      Colors.green,
      Colors.green[200],
      const Tablero(Nivel.facil)),
  Detalles("Medio",
      Colors.yellow,
      Colors.yellow[200],
      const Tablero(Nivel.medio)),
  Detalles("Dificil",
      Colors.orange,
      Colors.orange[200],
      const Tablero(Nivel.dificil)),
  Detalles("Imposible",
      Colors.red,
      Colors.red[200],
      const Tablero(Nivel.imposible)),
];

List<String> baraja =[];
List<FlipCardController> controles =[];
List<bool> estados = [];

void barajar(Nivel nivel){
  int size =0;

  switch(nivel){
    case Nivel.facil:
      size =16;
      break;
    case Nivel.medio:
      size =24;
      break;
    case Nivel.dificil:
      size =32;
      break;
    case Nivel.imposible:
      size =36;
      break;
  }
  for(int i=0;i<size;i++){
    controles.add(FlipCardController());
    estados.add(true);
  }
  baraja = cards().sublist(0,size);
  baraja.shuffle();
}