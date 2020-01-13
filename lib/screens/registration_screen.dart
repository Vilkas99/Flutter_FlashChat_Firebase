import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  //Establezco una variable estática (Debido a que esta tendrá el mismo valor para todos los objetos de esta clase)
  //...y por lo tanto, podrá ser accesada sin crear al objeto previamente (Útil para fijar las rutas).

  //Es constante porque nunca será modificada por el resto del código...

  static const String id = "/registro";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //Creamos dos variables que almacenarán el email y la contraseña del usuario en cuestión.
  String email;
  String contra;

  //Creamos un booleano que nos indicará si la app se encuentra cargando algún dato (En este caso, el registro del usuario)
  bool cargando = false;

  //Creamos un autentificador de nuestra librería de Firebase
  final autenticador = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //Widget que ejecuta una animación de un circulo 'cargando' cuando 'inAsyncCall' sea verdadero.
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
              Hero(
                tag: "rayo",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  //Cada vez que el valor del textField cambie, este se le asigna a email.
                  email = value;
                },
                decoration: kdecoracionInputEstilo.copyWith(
                    hintText: "Ingresa tu correo"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  //Cada vez que el valor del textField cambie, este se le asigna a contra.
                  contra = value;
                },
                decoration: kdecoracionInputEstilo.copyWith(
                    hintText: "Ingresa tu contraseña"),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      //Al presionar 'Registrasre'...
                      try {
                        //Actualizamos el estado de 'cargando' a true, debido a que la app estará cargando su registro.
                        setState(() {
                          cargando = true;
                        });

                        //Creamos un nuevo usuario con email y contra, y almacenamos el resultado en 'usuario'
                        final usuario =
                            await autenticador.createUserWithEmailAndPassword(
                                email: email, password: contra);
                        print(usuario);

                        //Si usuario no es nulo, entonces...
                        if (usuario != null) {
                          //Redireccionamos al usuario al chatscreen
                          Navigator.pushNamed(context, ChatScreen.id);
                        }

                        //Tras concretar el registro, cargando regresa a falso.
                        setState(() {
                          cargando = false;
                        });

                        //Si no logra realizar lo anterior, imprimimos el error que lo impide.
                      } catch (e) {
                        print(e);
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
