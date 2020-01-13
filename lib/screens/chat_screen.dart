import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Creamos una varaible 'firestore' que nos permitirá acceder al almacenamiento en la nube.
final _firestore = Firestore.instance;

//Creamos una variable que almacenará al usuario actual.
FirebaseUser miUsuario;

class ChatScreen extends StatefulWidget {
  //Establezco una variable estática (Debido a que esta tendrá el mismo valor para todos los objetos de esta clase)
  //...y por lo tanto, podrá ser accesada sin crear al objeto previamente (Útil para fijar las rutas).

  //Es constante porque nunca será modificada por el resto del código...

  static const String id = "/chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //Creamos un autenticador.
  final _autenticador = FirebaseAuth.instance;

  //Variable que almacena los mensajes del usuario
  String mensaje;

  //Creamos un controlador para el TextField en donde el usuario colocará su información.
  final controladorTextField = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Al momento de crear esta ventana, llamamos a 'obtenerUsuarioActual'.
    obtenerUsuarioActual();
  }

  //Método que obtiene al usuario actual.
  void obtenerUsuarioActual() async {
    try {
      //Almacenamos al usuario actual en una variable.
      final usuarioActual = await _autenticador.currentUser();
      //Si este no es nulo...
      if (usuarioActual != null) {
        //Establecemos que miUsuario es el usuario actual.
        miUsuario = usuarioActual;
        print(miUsuario);
      }
    } catch (e) {
      print(e);
    }
  }

  //Método que se encarga de obtener (De Firestore) los mensajes enviados.
  void streamMensajes() async {
    try {
      //Espera a que el siguiente proceso finalice...
      //Por cada snapshop en la colección de 'mensajes'...
      //Un sanpshot es una 'instantánea' de los mensajes presentes en ese momento.
      //Esta regresa un 'Stream' (Un conjunto de datos que se obtiene como se vayan creando) - Podemos relacionarlo con una banda de sushi.
      //Esto implica que cada vez que recibamos un nuevo mensaje, el codigo se ejecutará instantáneamente.
      await for (var snapshot
          in _firestore.collection('mensajes').snapshots()) {
        //Por cada mensaje que haya en los documentos de ese snapshot...
        for (var mensaje in snapshot.documents) {
          print(mensaje.data);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Cuando presionen el icono de cerrar, se salen de su cuenta.
                _autenticador.signOut();
                //Y los direccionamos a la página de login.
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Un stream builder es un widget que nos permite crear otros widgets con base en un stream de datos.

            StreamWidget(),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controladorTextField,
                      onChanged: (value) {
                        mensaje = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Limpiamos el TextField después de mandar el mensaje.
                      controladorTextField.clear();
                      //Al presionar 'Enviar', accederemos a la colección de mi firestore, llamada 'mensajes', y añadiremos (A través de un mapp)
                      //el email y el mensaje, a los campos adecuados (remitente y texto).
                      _firestore.collection('mensajes').add(
                          {'remitente': miUsuario.email, 'texto': mensaje});
                    },
                    child: Text(
                      'Enviar',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //Toma la base u origen de ese stream (El que provee los datos)
      stream: _firestore.collection('mensajes').snapshots(),
      //Establece un 'builder' que toma una función anónima para construir el widget
      //La función toma como arg el contexto y el pedazo de información del stream (En este caso, un snapshot)
      builder: (context, snapshot) {
        //Creamos una lista de widget de texto.
        List<BurbujaMensaje> mensajesW = [];

        //Si nuestro snapshot no tiene información...
        if (!snapshot.hasData) {
          //Regresaremos un indicador de progreso en el centro (Para denotar que seguimos cargando información).
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        //Creamos una variable que almacenará todos los documentos provistos por el snapshot.
        //Los obrtenemos al reves, con el fin de que los mensajes más recientes aparezcan hasta abajo de la lista.
        final mensajes = snapshot.data.documents.reversed;
        //Generamos un ciclo que corre por cada mensaje que haya en mensajes.
        for (var mensaje in mensajes) {
          //Obtenemos su texto y remitente.

          final mensajeTexto = mensaje.data['texto'];
          final remitente = mensaje.data['remitente'];

          final email = miUsuario.email;

          if (mensajeTexto != null) {
            print(mensajeTexto);
            //Generamos un widget de Texto y lo añadimos a nuestra lista.
            mensajesW.add(BurbujaMensaje(
              texto: mensajeTexto,
              remitente: remitente,
              soyYo: remitente == email,
            ));
          }
        }

        //Finalmente, regresamos una columna cuyo children son los mensajes.
        return Expanded(
          child: ListView(
            //Establecemos que la lista esta 'reversada', para que se scrolee hacia arriba y no hacia abajo (Porque los mensajes aparecen abajo)
            reverse: true,
            children: mensajesW,
          ),
        );
      },
    );
  }
}

class BurbujaMensaje extends StatelessWidget {
  BurbujaMensaje({this.texto, this.remitente, this.soyYo});

  final String texto;
  final String remitente;
  final bool soyYo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            soyYo ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            remitente,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          Material(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(texto,
                  style: TextStyle(
                      color: soyYo ? Colors.white : Colors.black,
                      fontSize: 15.0)),
            ),
            color: soyYo ? Colors.lightBlueAccent : Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: soyYo ? Radius.circular(10) : Radius.circular(0),
                topRight: soyYo ? Radius.circular(0) : Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            elevation: 10.0,
          )
        ],
      ),
    );
  }
}
