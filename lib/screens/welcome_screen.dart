import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/Componentes/botonesWelcome.dart';

class WelcomeScreen extends StatefulWidget {
  //Establezco una variable estática (Debido a que esta tendrá el mismo valor para todos los objetos de esta clase)
  //...y por lo tanto, podrá ser accesada sin crear al objeto previamente (Útil para fijar las rutas).

  //Es constante porque nunca será modificada por el resto del código...

  static const String id = "/";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    //Añadimos un 'mixin' (Un método que puede ser añadido a cualquier clase que utilize 'with') y que en este caso nos permitirá crear un 'ticker'
    //... para las animaciones.
    with
        SingleTickerProviderStateMixin {
  //Se crea un controlador de animación que será responsable de la animación del color del fondo.
  AnimationController controladorAnimacionFondo;
  //Creo una animación que será la animaciónde fondo.
  Animation animacionFondo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Al crearse la clase (initState) inicializo mi controlador de animación, en donde su vsync(contador o ticker) será el estado de la clase (this)
    //...y tendrá una duración de 3 segundos.
    controladorAnimacionFondo =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    //También añado un 'escucha' a mi controlador, con el fin de detectar cada uno de sus cambios, y activar un set state para actualizar los cambios.
    controladorAnimacionFondo.addListener(() {
      setState(() {});
    });

    //Inicializo mi animación de fondo, que será un intercambio de color de amarillo a blanco, y cuyo parent será el controlador,
    animacionFondo = ColorTween(begin: Colors.yellowAccent, end: Colors.white)
        .animate(controladorAnimacionFondo);

    //Finalmente, el controlador empieza a avanzar (De 0 a 1)
    controladorAnimacionFondo.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Cuando se destruya la ventana, también destruimos el controlador.
    controladorAnimacionFondo.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Se establece que el color del escenario será igual al valor que nos regresa la animaciónFondo
      backgroundColor: animacionFondo.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                //Un 'Hero' es un widget para crear animaciones de transicion, de dos elementos iguales que se encuentran en dos pantallas diferentes.
                //Requiere del elemento a transicionar (child) y del tag en común que comparten.
                //En este caso, la imagen del rayo será transicionada a dos paginas distintas (Registro y login).
                Hero(
                  tag: "rayo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  speed: Duration(milliseconds: 500),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            BotonesWelcome(
              miColor: Colors.lightBlueAccent,
              texto: 'Ingresar',
              alPresionar: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            BotonesWelcome(
              miColor: Colors.blueAccent,
              texto: 'Regístrate',
              alPresionar: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
