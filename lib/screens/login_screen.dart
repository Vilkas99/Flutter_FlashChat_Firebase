import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Componentes/botonesWelcome.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  //Establezco una variable estática (Debido a que esta tendrá el mismo valor para todos los objetos de esta clase)
  //...y por lo tanto, podrá ser accesada sin crear al objeto previamente (Útil para fijar las rutas).

  //Es constante porque nunca será modificada por el resto del código...

  static const String id = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String contra;

  bool cargando = false;

  final autenticador = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: cargando,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //Un 'Hero' es un widget para crear animaciones de transicion, de dos elementos iguales que se encuentran en dos pantallas diferentes.
              //Requiere del elemento a transicionar (child) y del tag en común que comparten.
              //En este caso, la imagen del rayo será transicionada a dos paginas distintas (Registro y login).
              Flexible(
                child: Hero(
                  tag: 'rayo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: kdecoracionInputEstilo.copyWith(
                    hintText: "Ingresa tu correo"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  onChanged: (value) {
                    contra = value;
                  },
                  decoration: kdecoracionInputEstilo.copyWith(
                      hintText: "Ingresa tu contraseña")),
              SizedBox(
                height: 24.0,
              ),
              BotonesWelcome(
                texto: "Ingresa",
                miColor: Colors.lightBlueAccent,
                alPresionar: () async {
                  setState(() {
                    cargando = true;
                  });

                  //Al presionar ingresar...
                  try {
                    print("Cargando...");
                    //Ejecutamos el método de signIn de nuestro autenticador, y almacenamos lo que nos regrese, en 'usuarioID'.
                    final usuarioID =
                        await autenticador.signInWithEmailAndPassword(
                            email: email, password: contra);
                    //Si el usuario no es nulo, entonce redirecionamos a la página de chat.
                    if (usuarioID != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    print(usuarioID);

                    setState(() {
                      cargando = false;
                    });
                  } catch (e) {
                    //Si no puede concretar el proceso anterior...
                    print("--------------ERROR----------");
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
